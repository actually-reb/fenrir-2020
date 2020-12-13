extends KinematicBody2D

onready var Global = get_node("/root/Global")
onready var invuln_timer = $InvulnTimer
onready var melee_attack_timer = $MeleeAttackTimer
onready var animated_sprite = $AnimatedSprite
onready var fish_sprite = $FishSprite
onready var tween = $Tween

var MELEE_ATTACK = preload("res://entity/MeleeAttack.tscn")

signal took_damage
signal died

var max_speed = 250
var accel = 3000
var decel = 3000
var velocity = Vector2()
var push_velocity = Vector2()
var push_decel = 1500

var melee_time = 0.5
var attack_held = false
var attacking = false

var health = 6

func _ready():
	pass

func _process(delta):
	if is_invuln():
		visible = not visible
	else:
		visible = true
	if attack_held and $MeleeAttackTimer.is_stopped():
		melee_attack((get_viewport().get_mouse_position() - position).normalized())

func _physics_process(delta):
	var move = Vector2()
	# Get movement input
	if Input.is_action_pressed("move_up"):
		move -= Vector2(0, 1)
	if Input.is_action_pressed("move_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		move -= Vector2(1, 0)
	if Input.is_action_pressed("move_right"):
		move += Vector2(1, 0)
	move = move.normalized()
	
	if not attacking:
		set_walk_animation(move)
	
	if move.x != 0 or move.y != 0:
		velocity += move * accel * delta
	else: # Decelerate if not moving
		velocity = velocity.normalized() * max(0, velocity.length() - decel * delta)
	
	if velocity.length() > max_speed: # Cap speed to max_speed
		velocity = velocity.normalized() * max_speed
	
	move_and_slide(velocity + push_velocity)
	
	push_velocity = push_velocity.normalized() * max(0, push_velocity.length() - push_decel * delta)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			attack_held = true

func set_walk_animation(dir):
	if dir == Vector2():
		animated_sprite.stop()
	else:
		if not animated_sprite.playing:
			animated_sprite.play()
		if dir.x != 0:
			if dir.x < 0:
				animated_sprite.animation = "left"
			else:
				animated_sprite.animation = "right"
		else:
			if dir.y < 0:
				animated_sprite.animation = "up"
			else:
				animated_sprite.animation = "down"

func melee_attack(dir):
	#if dir.x == 0 and dir.y == 0:
	#	dir = Vector2(0, 1)
	
	if melee_attack_timer.is_stopped():
		$MeleeSound.play()
		
		melee_attack_timer.wait_time = max(0.05, melee_time - log(Global.speed_powerups + 1) / 12)
		melee_attack_timer.start()
		attack_held = false
		var atk = MELEE_ATTACK.instance()
		atk.direction = dir
		add_child(atk)
		
		attacking = true
		var angle = dir.angle() + PI # very hacky fix for angle() returning negative numbers.
		fish_sprite.z_index = -1
		if angle > PI/4 and angle <= 3*PI/4:
			animated_sprite.animation = "attack_up"
			fish_sprite.position = $SwingUp.position
		elif angle > 3*PI/4 and angle <= 5*PI/4:
			animated_sprite.animation = "attack_right"
			fish_sprite.position = $SwingRight.position
		elif angle > 5*PI/4 and angle <= 7*PI/4:
			animated_sprite.animation = "attack_down"
			fish_sprite.position = $SwingDown.position
			fish_sprite.z_index = 0
		else:
			animated_sprite.animation = "attack_left"
			fish_sprite.position = $SwingLeft.position
		animated_sprite.play()
		
		fish_sprite.visible = true
		angle = dir.angle() + PI
		tween.interpolate_property(fish_sprite, 
		"rotation",
		angle + PI/4,
		angle - PI/1.5,
		0.25,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT)
		tween.start()

func is_invuln(): # Check if player is invulnerable to damage
	return not invuln_timer.is_stopped()

func damage(damage_amount, push):
	if is_invuln():
		return
	emit_signal("took_damage")
	health -= damage_amount
	$HurtSound.play()
	
	if health <= 0:
		die()
		return
	
	push_velocity = push
	velocity = Vector2()
	invuln_timer.start()

func die():
	emit_signal("died")
	queue_free()

func _on_Tween_tween_completed(object, key):
	attacking = false
	fish_sprite.visible = false
	animated_sprite.animation = animated_sprite.animation.substr(7)

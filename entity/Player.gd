extends KinematicBody2D

onready var invuln_timer = $InvulnTimer
onready var melee_attack_timer = $MeleeAttackTimer
onready var animated_sprite = $AnimatedSprite

var MELEE_ATTACK = preload("res://entity/MeleeAttack.tscn")

signal took_damage
signal died

var max_speed = 250
var accel = 3000
var decel = 3000
var velocity = Vector2()
var push_velocity = Vector2()
var push_decel = 1500

var health = 6

func _ready():
	pass

func _process(delta):
	if is_invuln():
		visible = not visible
	else:
		visible = true

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
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var mouse_dir = (event.position - position).normalized()
		melee_attack(mouse_dir)

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
	if melee_attack_timer.is_stopped():
		$MeleeSound.play()
		melee_attack_timer.start()
		var atk = MELEE_ATTACK.instance()
		atk.direction = dir
		add_child(atk)

func is_invuln(): # Check if player is invulnerable to damage
	return not invuln_timer.is_stopped()

func damage(damage_amount, push):
	if is_invuln():
		return
	emit_signal("took_damage")
	health -= damage_amount
	
	if health <= 0:
		die()
		return
	
	push_velocity = push
	velocity = Vector2()
	invuln_timer.start()

func die():
	emit_signal("died")
	queue_free()

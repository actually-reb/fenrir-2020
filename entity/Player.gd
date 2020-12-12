extends KinematicBody2D

onready var invuln_timer = $InvulnTimer

signal took_damage

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
	
	if move.x != 0 or move.y != 0:
		velocity += move * accel * delta
	else: # Decelerate if not moving
		velocity = velocity.normalized() * max(0, velocity.length() - decel * delta)
	
	if velocity.length() > max_speed: # Cap speed to max_speed
		velocity = velocity.normalized() * max_speed
	
	move_and_slide(velocity + push_velocity)
	
	push_velocity = push_velocity.normalized() * max(0, push_velocity.length() - push_decel * delta)

func is_invuln(): # Check if player is invulnerable to damage
	return not invuln_timer.is_stopped()

func damage(damage_amount, push):
	if is_invuln():
		return
	health -= damage_amount
	push_velocity = push
	velocity = Vector2()
	invuln_timer.start()
	emit_signal("took_damage")

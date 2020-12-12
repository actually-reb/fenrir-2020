extends KinematicBody2D

var max_speed = 250
var accel = 3000
var decel = 3000
var velocity = Vector2()

func _ready():
	pass

func _process(delta):
	pass

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
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	move_and_slide(velocity)

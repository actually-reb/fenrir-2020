extends KinematicBody2D

var speed = 300

func _ready():
	pass

func _process(delta):
	var move = Vector2(0, 0)
	if Input.is_action_pressed("move_up"):
		move -= Vector2(0, 1)
	if Input.is_action_pressed("move_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		move -= Vector2(1, 0)
	if Input.is_action_pressed("move_right"):
		move += Vector2(1, 0)
	move = move.normalized()
	
	move_and_slide(move * speed)

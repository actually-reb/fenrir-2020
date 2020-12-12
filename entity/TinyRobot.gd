extends KinematicBody2D

onready var sprite = $Sprite
var speed = 100

func _ready():
	pass # Replace with function body.

func _process(delta):
	var player_array = get_tree().get_nodes_in_group("player")
	var player
	if player_array.size() > 0:
		player = player_array[0]
	
	if player:
		sprite.flip_h = player.position.x < position.x
		var move = (player.position - position).normalized()
		move_and_slide(move * speed)

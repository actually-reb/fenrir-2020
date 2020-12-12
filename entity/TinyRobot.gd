extends KinematicBody2D

var speed = 100

func _ready():
	pass # Replace with function body.

func _process(delta):
	var player_array = get_tree().get_nodes_in_group("player")
	var player
	if player_array.size() > 0:
		player = player_array[0]
	
	if player:
		var move = (player.position - position).normalized()
		move_and_slide(move * speed)

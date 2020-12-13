extends Node2D

func _ready():
	pass

func set_floor_count(num):
	$FloorLabel.text = "You made it to floor " + str(num)

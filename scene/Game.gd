extends Node

var player

func _ready():
	var arr = get_tree().get_nodes_in_group("player")
	if arr.size() > 0:
		player = arr[0]

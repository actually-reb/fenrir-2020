extends Node

onready var health_bar = $HealthBar
var player

var floors = []

func _ready():
	var arr = get_tree().get_nodes_in_group("player")
	if arr.size() > 0:
		player = arr[0]
	
	var dir = Directory.new()
	if dir.open("res://floors/designs/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				floors.push_back(load("res://floors/designs/" + file_name))
				print(file_name)
			file_name = dir.get_next()
	
	$Room.load_floor(floors[0])

func _process(delta):
	if player:
		health_bar.set_health(player.health)
	else:
		health_bar.set_health(0)

extends Node

var ROOM = preload("res://scene/Room.tscn")
var PLAYER = preload("res://entity/Player.tscn")

onready var Global = get_node("/root/Global")
onready var health_bar = $HealthBar
var player

var room

var floors = []

func _ready():
	player = PLAYER.instance()
	
	var dir = Directory.new()
	if dir.open("res://floors/designs/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				floors.push_back(load("res://floors/designs/" + file_name))
				print(file_name)
			file_name = dir.get_next()
	
	randomize()
	Global.reset_game()
	load_room(random_floor())

func load_room(flr):
	room = ROOM.instance()
	call_deferred("add_child", room)
	room.load_floor(flr)
	room.connect("elevator_entered", self, "next_room")
	player.position = room.get_player_spawn()
	room.add_child(player)

func next_room():
	Global.current_floor += 1
	room.remove_child(player)
	call_deferred("remove_child", room)
	room.queue_free()
	load_room(random_floor())

func random_floor():
	return floors[randi() % floors.size()]

func _process(delta):
	if player:
		health_bar.set_health(player.health)
	else:
		health_bar.set_health(0)

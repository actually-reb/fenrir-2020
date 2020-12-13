extends Node

var ROOM = preload("res://scene/Room.tscn")
var PLAYER = preload("res://entity/Player.tscn")

onready var Global = get_node("/root/Global")
onready var health_bar = $HealthBar
var player

var room

var floors = []
var item_floors = []

func _ready():
	player = PLAYER.instance()
	
	var dir = Directory.new()
	if dir.open("res://floors/designs/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				floors.push_back(load("res://floors/designs/" + file_name))
			file_name = dir.get_next()
	
	if dir.open("res://floors/item/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				item_floors.push_back(load("res://floors/item/" + file_name))
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
	if Global.current_floor % 5 == 1:
		load_room(random_item_floor())
	else:
		load_room(random_floor())

func random_floor():
	return floors[randi() % floors.size()]

func random_item_floor():
	return item_floors[randi() % item_floors.size()]

func _process(delta):
	if player:
		health_bar.set_health(player.health)
	else:
		health_bar.set_health(0)

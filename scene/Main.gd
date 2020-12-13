extends Node

var TITLE = preload("res://scene/Title.tscn")
var GAME = preload("res://scene/Game.tscn")

var game

func _ready():
	pass

func load_game():
	game = GAME.instance()
	game.connect("restarted", self, "new_game")
	call_deferred("add_child", game)

func new_game():
	remove_child(game)
	game.queue_free()
	load_game()

func _on_Title_started():
	$Title.queue_free()
	load_game()

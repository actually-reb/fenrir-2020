extends Node

var current_floor
var speed_powerups
var width_powerups

func _ready():
	reset_game()

func reset_game():
	current_floor = 1
	speed_powerups = 0
	width_powerups = 0

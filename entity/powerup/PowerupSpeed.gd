extends "res://entity/powerup/PowerupBase.gd"

onready var Global = get_node("/root/Global")

func _ready():
	pass

func collect(player):
	Global.speed_powerups += 1

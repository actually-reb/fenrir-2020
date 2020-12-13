extends "res://entity/powerup/PowerupBase.gd"

onready var Global = get_node("/root/Global")

func _ready():
	pass

func collect(player):
	Global.width_powerups += 1

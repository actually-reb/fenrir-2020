extends "res://entity/powerup/PowerupBase.gd"

func _ready():
	pass

func collect(player):
	player.health += 4

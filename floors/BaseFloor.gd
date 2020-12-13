extends Node2D

var powerups

func _ready():
	powerups = get_tree().get_nodes_in_group("powerup")
	for p in powerups:
		p.connect("powerup_collected", self, "remove_powerups")

func remove_powerups():
	for p in powerups:
		p.queue_free()

extends Node

onready var health_bar = $HealthBar
var player

func _ready():
	var arr = get_tree().get_nodes_in_group("player")
	if arr.size() > 0:
		player = arr[0]

func _process(delta):
	if player:
		health_bar.set_health(player.health)
	else:
		health_bar.set_health(0)

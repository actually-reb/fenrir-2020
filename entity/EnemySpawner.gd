extends Position2D

export var spawn_one = false

var TINY_ROBOT = preload("res://entity/TinyRobot.tscn")

func _ready():
	if spawn_one:
		spawn_tiny_robots(1)
	else:
		var global = get_node("/root/Global")
		spawn_tiny_robots(min(global.current_floor, 25))

func spawn_tiny_robots(num):
	var space = 32
	var width = ceil(sqrt(num)) * space
	var x = -width / 2
	var y = -width / 2
	for i in range(num):
		var inst = TINY_ROBOT.instance()
		inst.position = position + Vector2(x, y)
		get_parent().get_parent().add_enemy(inst)
		x += space
		if x >= width / 2:
			x = -width / 2
			y += space

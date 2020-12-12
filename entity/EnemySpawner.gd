extends Position2D

var TINY_ROBOT = preload("res://entity/TinyRobot.tscn")

func _ready():
	spawn_tiny_robots(9)

func spawn_tiny_robots(num):
	var space = 40
	var width = ceil(sqrt(num)) * space
	var x = -width / 2
	var y = -width / 2
	for i in range(num):
		var inst = TINY_ROBOT.instance()
		inst.position = position + Vector2(x, y)
		get_parent().add_enemy(inst)
		x += space
		if x >= width / 2:
			x = -width / 2
			y += space

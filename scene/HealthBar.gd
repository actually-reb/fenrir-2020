extends Node2D

var HEART_FULL = load("res://sprite/heart_full.png")
var HEART_HALF = load("res://sprite/heart_half.png")
var health

func _ready():
	set_health(6)

func set_health(num):
	if health != num:
		health = num
		var i = 0
		
		for n in get_children():
			remove_child(n)
			n.queue_free()
		
		while i * 2 < health:
			var s = Sprite.new()
			if health - (i * 2) == 1:
				s.texture = HEART_HALF
			else:
				s.texture = HEART_FULL
			s.position.y = i * 36
			add_child(s)
			i += 1

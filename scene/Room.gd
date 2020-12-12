extends Node2D

func _ready():
	pass

func add_enemy(enemy):
	call_deferred("add_child", enemy)

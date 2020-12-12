extends Node2D

onready var elevator = $Elevator

var enemy_count = 0

func _ready():
	pass

func add_enemy(enemy):
	call_deferred("add_child", enemy)
	enemy.connect("died", self, "_on_enemy_died")
	enemy_count += 1

func _on_enemy_died():
	enemy_count -= 1
	if enemy_count <= 0:
		elevator.open()

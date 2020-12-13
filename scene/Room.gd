extends Node2D

signal elevator_entered

onready var elevator = $Elevator

var enemy_count = 0

func _ready():
	pass

func load_floor(flr):
	call_deferred("add_child", flr.instance())

func add_enemy(enemy):
	call_deferred("add_child", enemy)
	enemy.connect("died", self, "_on_enemy_died")
	enemy_count += 1

func get_player_spawn():
	return Vector2(634, 616)

func _on_enemy_died():
	enemy_count -= 1
	if enemy_count <= 0:
		elevator.open()

func _on_Elevator_elevator_entered():
	emit_signal("elevator_entered")

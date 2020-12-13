extends Node2D

signal started

func _ready():
	pass

func _on_StartButton_pressed():
	emit_signal("started")

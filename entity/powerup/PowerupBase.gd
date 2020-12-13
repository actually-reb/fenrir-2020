extends Area2D

signal powerup_collected

func _ready():
	pass

func collect(player):
	pass

func _on_PowerupBase_body_entered(body):
	if body and body.is_in_group("player"):
		collect(body)
		emit_signal("powerup_collected")

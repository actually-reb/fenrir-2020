extends Area2D

signal powerup_collected
var time = 0

func _ready():
	time += randf() * 2 * PI

func _process(delta):
	time += delta * 4
	$Sprite.position.y = sin(time) * 3

func collect(player):
	pass

func _on_PowerupBase_body_entered(body):
	if body and body.is_in_group("player"):
		collect(body)
		emit_signal("powerup_collected")

extends Area2D

signal elevator_entered

var is_open = false

func _ready():
	pass

func _process(delta):
	if $AnimatedSprite.frame == 3:
		$AnimatedSprite.stop()

func open():
	$AnimatedSprite.play()
	is_open = true
	$CollisionShape2D.disabled = false
	$AudioStreamPlayer.play()

func _on_Elevator_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("elevator_entered")

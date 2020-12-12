extends Area2D

var direction = Vector2()
var speed = 1000

func _ready():
	pass

func _physics_process(delta):
	rotation = direction.angle()
	
	position += direction * speed * delta
	
	speed -= 5000 * delta
	if speed < 0:
		queue_free()

func _on_MeleeAttack_body_entered(body):
	if body.is_in_group("enemy") and body.has_method("damage"):
		body.damage(1, direction * 500)

extends KinematicBody2D

onready var sprite = $Sprite
onready var hop_timer = $HopTimer
var speed = 100
var direction = Vector2()
var hop_time = 0.2
var hop_interval = 0.3
var push_velocity = Vector2()
var push_decel = 1500

var health = 2

func _ready():
	hop_timer.wait_time = randf() * hop_interval # Randomize start
	hop_timer.start()

func _process(delta):
	var time = min(1, hop_timer.time_left / hop_time)
	sprite.position.y = sin(time * PI) * -4

func _physics_process(delta):
	if hop_timer.time_left < hop_time:
		move_and_slide(direction * speed)
	
	push_velocity = push_velocity.normalized() * max(0, push_velocity.length() - push_decel * delta)
	
	var reversed = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		if collider.is_in_group("player"):
			collider.damage(1, direction * 400)
			if not reversed:
				direction = -direction
				reversed = true

func hop_towards(pos):
	direction = (pos - position).normalized()

func _on_HopTimer_timeout():
	if hop_timer.wait_time != hop_time:
		hop_timer.wait_time = hop_time
		hop_timer.start()
	
	# Get player node
	var player_array = get_tree().get_nodes_in_group("player")
	var player
	if player_array.size() > 0:
		player = player_array[0]
	
	if player:
		sprite.flip_h = player.position.x < position.x
		hop_towards(player.position)
	else:
		direction = Vector2()

func damage(damage_amount, push):
	health -= damage_amount
	if health <= 0:
		die()
	push_velocity = push

func die():
	queue_free()

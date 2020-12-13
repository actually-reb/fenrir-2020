extends KinematicBody2D

signal died

onready var sprite = $Sprite
onready var hop_timer = $HopTimer
onready var wait_timer = $WaitTimer
var base_speed = 150
var speed = 150
var direction = Vector2()
var hop_time = 0.2
var hop_interval = 0.3
var push_velocity = Vector2()
var push_decel = 1500

var random_hops = 0

var health = 2

func _ready():
	hop_timer.wait_time = randf() * hop_interval # Randomize start
	hop_timer.start()
	wait_timer.wait_time = randf() * 1 + 0.2
	wait_timer.start()
	base_speed = 130 + (randi() % 180)

func _process(delta):
	var time = min(1, hop_timer.time_left / hop_time)
	sprite.position.y = sin(time * PI) * -4

func _physics_process(delta):
	if hop_timer.time_left < hop_time:
		move_and_slide(direction * speed + push_velocity)
	
	push_velocity = push_velocity.normalized() * max(0, push_velocity.length() - push_decel * delta)
	
	var reversed = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		if collider and collider.is_in_group("player"):
			collider.damage(1, direction * 450)
			if not reversed:
				direction = -direction
				reversed = true
		if collider and collider.is_in_group("wall"):
			if not random_hops > 0:
				random_hops = 3
		if collider and collider.is_in_group("enemy"):
			if not random_hops > 0:
				random_hops = 1

func hop_towards_dir(dir):
	direction = dir

func hop_towards(pos):
	hop_towards_dir((pos - position).normalized())

func _on_HopTimer_timeout():
	if hop_timer.wait_time != hop_time:
		hop_timer.wait_time = hop_time
		hop_timer.start()
	
	if not wait_timer.is_stopped():
		return
	
	if random_hops > 0:
		var r = randf() * PI * 2
		var rand_dir = Vector2(cos(r), sin(r))
		hop_towards_dir(rand_dir)
		random_hops -= 1
	else:
		# Get player node
		var player_array = get_tree().get_nodes_in_group("player")
		var player
		if player_array.size() > 0:
			player = player_array[0]
		
		if player:
			sprite.flip_h = player.position.x < position.x
			speed = base_speed + (randi() % 50)
			hop_towards(player.position)
		else:
			direction = Vector2()

func damage(damage_amount, push):
	health -= damage_amount
	if health <= 0:
		die()
	else:
		$HurtSound.play()
	push_velocity = push

func die():
	var hs = $HurtSound
	
	hs.pitch_scale = 1.2
	hs.play()
	
	hs.connect("finished", $HurtSound, "queue_free")
	remove_child(hs)
	get_parent().add_child(hs)
	emit_signal("died")
	queue_free()

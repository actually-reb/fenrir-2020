extends AnimatedSprite

func _ready():
	frame = randi() % 2
	playing = true

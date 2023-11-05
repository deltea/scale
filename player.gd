extends CharacterBody2D

@export var MOVE_SPEED = 6000

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var x_input = Input.get_axis("left", "right")
	var y_input = Input.get_axis("up", "down")

	if x_input or y_input:
		sprite.animation = "Run"
	else:
		sprite.animation = "Idle"

	velocity = Vector2(x_input, y_input) * MOVE_SPEED * delta

	move_and_slide()
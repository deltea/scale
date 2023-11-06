extends CharacterBody2D
class_name Player

@export var move_speed = 6000

@onready var sprite := $AnimatedSprite2D
@onready var dash := $Dash as Dash

func _physics_process(delta: float) -> void:
	var x_input = Input.get_axis("left", "right")
	var y_input = Input.get_axis("up", "down")

	sprite.flip_h = get_global_mouse_position().x < position.x

	if x_input or y_input:
		sprite.animation = "Run"
	else:
		sprite.animation = "Idle"

	if Input.is_action_just_pressed("dash"):
		dash.start_dash()

	var speed = dash.speed if dash.is_dashing() else move_speed
	velocity = Vector2(x_input, y_input) * speed * delta

	move_and_slide()

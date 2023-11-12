extends CharacterBody2D
class_name Player

@export var move_speed = 6000
@export var item_hold_distance = 15
@export var item_throw_force = 800
@export var item_throw_torque = 100

@onready var sprite := $AnimatedSprite2D
@onready var dash := $Dash as Dash
@onready var item_transform = $ItemTransform

var throwableTouching: Throwable = null
var currentThrowable: Throwable = null

func _ready():
	Globals.player = self

func _physics_process(delta: float) -> void:
	var x_input = Input.get_axis("left", "right")
	var y_input = Input.get_axis("up", "down")

	sprite.flip_h = get_global_mouse_position().x < position.x

	if x_input != 0:
		if sprite.flip_h:
			sprite.speed_scale = -x_input
		else:
			sprite.speed_scale = x_input

	if x_input or y_input:
		sprite.animation = "Run"
	else:
		sprite.animation = "Idle"

	if Input.is_action_just_pressed("dash"):
		dash.start_dash()

	if Input.is_action_just_pressed("action") and throwableTouching:
		currentThrowable = throwableTouching
		currentThrowable.freeze = true
		currentThrowable.y_sort_enabled = true
		currentThrowable.z_index = 0
		item_transform.remote_path = currentThrowable.get_path()

	if Input.is_action_just_pressed("throw") and currentThrowable:
		var throwDir = to_local(get_global_mouse_position()).normalized()
		item_transform.remote_path = ""
		currentThrowable.freeze = false
		currentThrowable.y_sort_enabled = false
		currentThrowable.z_index = -10
		currentThrowable.apply_impulse(throwDir * item_throw_force)
		currentThrowable.apply_torque_impulse(item_throw_torque * (1 if randf() > 0.5 else -1))
		currentThrowable = null

	var speed = dash.speed if dash.is_dashing() else move_speed
	velocity = Vector2(x_input, y_input) * speed * delta

	if dash.is_dashing(): sprite.animation = "Dash"

	move_and_slide()

func _process(_delta: float) -> void:
	var mouse_dir = to_local(get_global_mouse_position()).normalized()
	item_transform.position = mouse_dir * item_hold_distance

func _on_item_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Throwable:
		throwableTouching = area.get_parent()
		print("Touching throwable")

func _on_item_area_area_exited(area:Area2D) -> void:
	if area.get_parent() is Throwable:
		throwableTouching = null
		print("Exit throwable")

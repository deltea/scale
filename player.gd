extends CharacterBody2D
class_name Player

@export var move_speed = 6000
@export var item_hold_distance = 15
@export var item_throw_force = 800
@export var item_throw_torque = 100

@onready var sprite := $AnimatedSprite2D
@onready var dash := $Dash as Dash
@onready var item_transform = $ItemTransform

var throwable_touching: Throwable = null
var current_throwable: Throwable = null

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

	if Input.is_action_just_pressed("action") and throwable_touching:
		current_throwable = throwable_touching
		current_throwable.freeze = true
		current_throwable.y_sort_enabled = true
		current_throwable.z_index = 0
		current_throwable.rotation = 0
		item_transform.remote_path = current_throwable.get_path()

	if Input.is_action_just_pressed("throw") and current_throwable:
		var throwDir = to_local(get_global_mouse_position()).normalized()
		item_transform.remote_path = ""
		current_throwable.freeze = false
		current_throwable.y_sort_enabled = false
		current_throwable.z_index = -10
		current_throwable.apply_impulse(throwDir * item_throw_force)
		current_throwable.apply_torque_impulse(item_throw_torque * (1 if randf() > 0.5 else -1))
		current_throwable = null

	if current_throwable is Gun:
		current_throwable.look_at(get_global_mouse_position())
		var gun_sprite = current_throwable.get_node("Sprite2D") as Sprite2D
		gun_sprite.flip_v = not (current_throwable.rotation_degrees > -90 and current_throwable.rotation_degrees < 90)

		if Input.is_action_just_pressed("use"):
			(current_throwable as Gun).shoot()

	var speed = dash.speed if dash.is_dashing() else move_speed
	velocity = Vector2(x_input, y_input) * speed * delta

	if dash.is_dashing(): sprite.animation = "Dash"

	move_and_slide()

func _process(_delta: float) -> void:
	var mouse_dir = to_local(get_global_mouse_position()).normalized()
	item_transform.position = mouse_dir * item_hold_distance

func _on_item_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Throwable:
		throwable_touching = area.get_parent()
		print("Touching throwable")

func _on_item_area_area_exited(area:Area2D) -> void:
	if area.get_parent() is Throwable:
		throwable_touching = null
		print("Exit throwable")

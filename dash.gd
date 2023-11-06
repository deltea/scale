extends Node2D
class_name Dash

@export var sprite: AnimatedSprite2D
@export var speed = 18000
@export var duration = 0.2
@export var delay = 0.4
@export var ghost_duration = 0.2
@export var ghost_delay = 0.02

@onready var duration_timer := $DurationTimer

var ghost_scene = preload("res://dash_ghost.tscn")
var can_dash = true
var ghost_timer: float = 0

func _process(delta: float) -> void:
	ghost_timer += delta
	if ghost_timer >= ghost_delay and is_dashing():
		ghost_timer = 0
		instance_ghost()

func start_dash():
	if not can_dash or is_dashing(): return

	duration_timer.wait_time = duration
	duration_timer.start()

func is_dashing():
	return not duration_timer.is_stopped()

func end_dash():
	can_dash = false
	await get_tree().create_timer(delay).timeout
	can_dash = true

func instance_ghost():
	var ghost = ghost_scene.instantiate() as DashGhost

	ghost.global_position = global_position
	ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h
	ghost.duration = ghost_duration

	get_parent().get_parent().add_child(ghost)

func _on_duration_timer_timeout() -> void:
	end_dash()

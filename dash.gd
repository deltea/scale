extends Node2D
class_name Dash

@export var SPRITE: AnimatedSprite2D
@export var SPEED = 18000
@export var DURATION = 0.2
@export var DELAY = 0.4
@export var GHOST_DURATION = 0.2
@export var GHOST_DELAY = 0.02

@onready var duration_timer := $DurationTimer

var ghost_scene = preload("res://dash_ghost.tscn")
var can_dash = true
var ghost_timer: float = 0

func _process(delta: float) -> void:
	ghost_timer += delta
	if ghost_timer >= GHOST_DELAY and is_dashing():
		print("ghost")
		ghost_timer = 0
		instance_ghost()

func start_dash():
	if not can_dash or is_dashing(): return

	duration_timer.wait_time = DURATION
	duration_timer.start()

func is_dashing():
	return not duration_timer.is_stopped()

func end_dash():
	can_dash = false
	await get_tree().create_timer(DELAY).timeout
	can_dash = true

func instance_ghost():
	var ghost = ghost_scene.instantiate() as DashGhost

	ghost.global_position = global_position
	ghost.texture = SPRITE.sprite_frames.get_frame_texture(SPRITE.animation, SPRITE.frame)
	ghost.flip_h = SPRITE.flip_h
	ghost.duration = GHOST_DURATION

	get_parent().get_parent().add_child(ghost)

func _on_duration_timer_timeout() -> void:
	end_dash()

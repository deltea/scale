extends CharacterBody2D
class_name Enemy

enum STATE { PATROL, CHASE }

@export var patrol_speed = 50
@export var chase_speed = 100

@onready var sprite := $AnimatedSprite2D
@onready var raycast := $PlayerRaycast
@onready var nav_agent := $NavigationAgent2D

var state = STATE.PATROL
var old_x: float

func _physics_process(delta: float) -> void:
	match state:
		STATE.PATROL: patrol_state(delta)
		STATE.CHASE: chase_state(delta)

func patrol_state(delta: float):
	sprite.flip_h = position.x < old_x
	old_x = position.x

	raycast.look_at(Globals.player.position)

	if raycast.get_collider() is Player:
		state = STATE.CHASE

func chase_state(delta: float):
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * chase_speed
	move_and_slide()

func create_path() -> void:
	nav_agent.target_position = Globals.player.global_position

func _on_navigation_timer_timeout() -> void:
	create_path()

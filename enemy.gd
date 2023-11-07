extends CharacterBody2D
class_name Enemy

enum STATE { PATROL, CHASE }

@export var patrol_speed = 50
@export var chase_speed = 100
@export var patrol_path: Curve2D

@onready var sprite := $AnimatedSprite2D
@onready var raycast := $PlayerRaycast
@onready var nav_agent := $NavigationAgent2D

var state = STATE.PATROL

func _physics_process(delta: float) -> void:
	raycast.look_at(Globals.player.position)

	match state:
		STATE.PATROL: patrol_state(delta)
		STATE.CHASE: chase_state()

func patrol_state(delta: float):
	if raycast.get_collider() is Player:
		state = STATE.CHASE

func chase_state():
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * chase_speed
	sprite.flip_h = direction.x < 0

	if not raycast.get_collider() is Player: state = STATE.PATROL

	move_and_slide()

func _on_navigation_timer_timeout() -> void:
	nav_agent.target_position = Globals.player.global_position

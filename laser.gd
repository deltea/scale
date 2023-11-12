extends Line2D
class_name Laser

@export var duration = 50

func _process(delta: float) -> void:
	width = move_toward(width, 0, duration * delta)
	if width <= 0:
		queue_free()

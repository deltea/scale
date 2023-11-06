extends TextureRect

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position = event.position - size / 2

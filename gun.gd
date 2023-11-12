extends Throwable
class_name Gun

@export var fire_rate = 3

@onready var laser_raycast := $RayCast2D as RayCast2D

var laser_scene = preload("res://laser.tscn")

func shoot():
	var laser = laser_scene.instantiate() as Laser
	laser.set_point_position(0, global_position)
	laser.set_point_position(1, laser_raycast.get_collision_point())
	get_node("/root/Main/World").add_child(laser)

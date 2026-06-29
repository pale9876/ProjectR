# player_camera.gd
extends Camera2D


# Import
const Player = preload("uid://c2uxhumgng18h")


var force: Vector2
var time: float


@export var time_scale: float = 3.


func _physics_process(delta: float) -> void:
	if time > 0.:
		force = - force
		
		offset = offset.lerp(force, randf_range(.125, .225))
		force = force.lerp(Vector2(), randf_range(.095, .225))
		time = maxf(0., time - (delta * time_scale))


func shake(_force: Vector2, _time: float) -> void:
	force = _force
	time = _time


func get_player() -> Player:
	return get_parent() as Player

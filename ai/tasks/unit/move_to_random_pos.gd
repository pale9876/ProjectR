# move_to_random_pos.gd
@tool
extends BTAction


const Unit: Script = preload("uid://bl84ixx4kubfe")


@export var move_distance: float = 100.
@export var speed_scale: float = .5

@export var duration: float = 5.
var _duration: float = 0.

var _destination_pos: Vector2


func _enter() -> void:
	var unit: Unit = agent as Unit
	_destination_pos = unit.global_position + (move_distance * get_rand_dir())
	_duration = duration


func _tick(_delta: float) -> Status:
	var unit: Unit = agent as Unit
	
	if blackboard.get_var(&"target") != null:
		return FAILURE


	if _duration > 0.:
		var _motion: Vector2 = unit.stat.speed * unit.global_position.direction_to(_destination_pos) * speed_scale
		unit.velocity = unit.velocity.move_toward(_motion, unit.stat.speed * _delta)
		_duration -= _delta
		unit.move_and_slide()
	else:
		return SUCCESS
	
	return RUNNING


func get_rand_dir() -> Vector2:
	var rand_dir: int = 1 if randi_range(-1, 1) == 0 else -1
	return Vector2(float(rand_dir), float(rand_dir)).normalized()


func _generate_name() -> String:
	return str(duration) + "초 동안 " + str(move_distance) + "의 거리만큼 랜덤방향으로 이동"

# go_to_rand_progress.gd
extends BTAction

# Import
const PathedUnit: Script = preload("uid://dqd845y1secly")

@export var max_dist: float = .15
@export var min_dist: float = .55

@export var max_speed_scale: float = .1
@export var min_speed_scale: float = .2


var _tolorance: float
var _direction: float
var _speed_scale: float


func _enter() -> void:
	_direction = get_rand_direction()
	_tolorance = randf_range(min_dist, max_dist)
	_speed_scale = randf_range(min_speed_scale, max_speed_scale)


func _tick(delta: float) -> Status:
	var move_dist: float = _speed_scale * delta
	var unit := agent as PathedUnit
	
	unit.progress_ratio += move_dist * _direction
	_tolorance = maxf(_tolorance - move_dist, 0.)
	
	if _tolorance == 0. or (unit.progress_ratio >= 1. or unit.progress_ratio <= 0.):
		return SUCCESS
	
	return RUNNING


func get_rand_direction() -> float:
	var unit := agent as PathedUnit
	
	return (
		[-1., 1.].pick_random() if !(unit.progress_ratio >= 1. or unit.progress_ratio <= 0.)
			else 1. if (unit.progress_ratio <= 0.)
				else - 1.
	) 

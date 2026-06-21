# patrol_wait.gd
@tool
extends BTAction

@export var duration: float = 5.
var _duration: float = 0.

const Unit: Script = preload("uid://bl84ixx4kubfe")


func _enter() -> void:
	var unit = agent as Unit
	unit.anim.play(&"idle")
	_duration = duration

func _tick(_delta: float) -> Status:
	if blackboard.get_var(&"target") != null || _duration < 0.:
		return FAILURE
	
	_duration -= _delta
	
	return RUNNING

func _generate_name() -> String:
	return "Patrol Wait :: " + str(duration) + " seconds"

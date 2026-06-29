# patrol_wait.gd
@tool
extends BTAction

@export var duration: float = 5.
var _duration: float = 0.



func _generate_name() -> String:
	return "정찰 쉬기 :: " + str(duration) + " 초만큼 쉼"


func _enter() -> void:
	var unit = agent as Unit
	unit.anim.play(&"idle")
	_duration = duration


func _tick(_delta: float) -> Status:
	if blackboard.get_var(&"target") != null || _duration < 0.:
		return FAILURE
	
	_duration -= _delta
	
	return RUNNING

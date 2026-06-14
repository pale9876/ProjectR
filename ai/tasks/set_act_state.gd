@tool
extends BTAction


const Unit: Script = preload("uid://bl84ixx4kubfe")


func _generate_name() -> String:
	return "행동 상태를 설정"


func _enter() -> void:
	blackboard.set_var(&"act", "patrol")


func _tick(_delta: float) -> Status:
	blackboard.set_var(&"act", "trace" if blackboard.get_var(&"target") != null else "patrol")
	
	return SUCCESS

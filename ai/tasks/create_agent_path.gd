extends BTAction


const Unit: Script = preload("uid://bl84ixx4kubfe")


func _enter() -> void:
	var unit: Unit = agent as Unit
	var target: Node2D = blackboard.get_var(&"target") as Node2D
	unit.agent.target_position = target.global_position


func _tick(delta: float) -> Status:
	
	return SUCCESS

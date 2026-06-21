extends BTAction


func _tick(_delta: float) -> Status:
	return SUCCESS if (blackboard.get_var(&"target") as Node2D) != null else FAILURE

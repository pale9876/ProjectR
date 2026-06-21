@tool
extends BTAction


func _generate_name() -> String:
	return "추격 또는 발견상태가 아닐 때에 타겟 유무 확인"


func _tick(_delta: float) -> Status:
	return FAILURE if blackboard.get_var(&"target") != null else SUCCESS

# run_in_opposite_direction.gd
@tool
extends BTAction


const PathedUnit: Script = preload("uid://dqd845y1secly")


func _generate_name() -> String:
	return "타겟과 반대쪽으로 도망가기"


func _enter() -> void:
	pass


func _tick(_delta: float) -> Status:
	var target := (blackboard.get_var(&"target") as Node2D)
	var unit := agent as PathedUnit
	
	if target:
		var target_pos: Vector2 = (blackboard.get_var(&"target") as Node2D).global_position
		var target_dir: float = roundf(unit.global_position.direction_to(target_pos).x)
		unit.progress += unit.stat.speed * target_dir * _delta
		
		return RUNNING
	else:
		if unit.progress_ratio >= 1. or unit.progress_ratio <= 0.:
			return SUCCESS

	return SUCCESS

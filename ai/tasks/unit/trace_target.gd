# trace_target.gd
@tool
extends BTAction


const Unit = preload("uid://bl84ixx4kubfe")


func _generate_name() -> String:
	return "타겟을 향하여 이동"


func _enter() -> void:
	pass


func _tick(delta: float) -> Status:
	var unit: Unit = agent as Unit
	
	if blackboard.get_var(&"target") == null:
		return FAILURE

	var target_dir: Vector2 = unit.global_position.direction_to((blackboard.get_var(&"target") as Node2D).global_position)
	unit.velocity = unit.velocity.move_toward(
		unit.stat.speed * target_dir, unit.stat.speed * delta
	)
	unit.move_and_slide()
	
	return RUNNING

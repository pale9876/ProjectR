extends LimboState


const Unit: Script = preload("uid://bl84ixx4kubfe")


func _enter() -> void:
	pass


func _update(delta: float) -> void:
	var unit: Unit = agent as Unit
	var velocity: Vector2 = unit.velocity
	var target_pos: Vector2 = agent.get_next_path_position()
	var motion_length: float
	
	velocity = velocity.move_toward(target_pos, motion_length * delta)

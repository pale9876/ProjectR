# unit/move.gd
extends UnitState


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	var unit := _get_unit()
	var target := get_bb_var(&"target") as Node2D;
	
	var direction: Vector2 = unit.global_position.direction_to(target.global_position)
	
	
	if target != null:
		var motion: float = direction.x * unit.stat.speed


func _exit() -> void:
	pass

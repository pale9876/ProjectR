# unit/state/fall.gd
extends UnitState



func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	var unit := get_unit()
	
	if is_on_floor():
		unit.velocity.y = move_toward(unit.velocity.y, 970., 12.25)
	
	move_and_slide()

# unit/state/down.gd
extends UnitState


func _enter_tree() -> void:
	add_library()


func _enter() -> void:
	play(&"down")


func _update(delta: float) -> void:
	var hsm := get_state_machine()
	
	get_friction()
	move_and_slide()
	
	if hsm.unlocked():
		hsm.revert()

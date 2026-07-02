#unit/knockback.gd
extends UnitState


func _enter_tree() -> void:
	add_library()


func _enter() -> void:
	pass



func _update(delta: float) -> void:
	var state_machine := get_state_machine()
	var unit := get_unit()
	
	unit.velocity.x = move_toward(unit.velocity.x, 0., 15.25)
	
	if !is_on_floor():
		unit.velocity.y = move_toward(unit.velocity.y, 970., 15.25)
	
	move_and_slide()
	
	
	if state_machine.unlocked():
		state_machine.dispatch(&"revert")



func event(info: HitboxInformation) -> void:
	var hsm := get_state_machine()
	if info.type == HitboxInformation.AERIAL:
		get_hsm().change_active_state(get_state(^"Aerial"))


func _exit() -> void:
	pass

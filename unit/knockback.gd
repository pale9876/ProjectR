#unit/knockback.gd
extends UnitState


func _enter_tree() -> void:
	add_library()


func _enter() -> void:
	#get_unit().velocity.y = 0.
	play(&"knockback")


func _update(delta: float) -> void:
	var state_machine := get_state_machine()
	var unit := get_unit()
	
	unit.velocity.x = move_toward(unit.velocity.x, 0., 15.25)
	
	move_and_slide()

	if !is_on_floor():
		unit.velocity.y = move_toward(unit.velocity.y, 970., 15.25)
	
	if state_machine.unlocked():
		state_machine.dispatch(&"revert")
		print("unlocked")


func event(info: HitboxInformation, _result: HitResult) -> void:
	var hsm := get_state_machine()
	
	match info.type:
		HitboxInformation.AERIAL:
			var aerial := get_state(^"Aerial")
			hsm.init_hurt_state(info, _result, aerial)
		HitboxInformation.KNOCKBACK:
			hsm.init_hurt_state(info, _result, self)
		


func _exit() -> void:
	pass

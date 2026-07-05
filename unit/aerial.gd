extends UnitState



func _enter_tree() -> void:
	add_library()


func _enter() -> void:
	play(&"aerial")



func _update(delta: float) -> void:
	var unit := get_unit()
	var hsm := get_hsm() as StateMachine
	
	move_and_slide()
	
	if is_on_floor():
		hsm.set_lock_frame(30)
		hsm.change_active_state(get_state(^"Down"))
	else:
		get_gravity(2250., 25.25)

func event(info: HitboxInformation, result: HitResult) -> void:
	match info.type:
		HitboxInformation.KNOCKBACK:
			pass
		
		HitboxInformation.AERIAL:
			pass
	

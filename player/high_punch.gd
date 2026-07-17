extends PlayerActive


func _ready() -> void:
	pass
	#get_anim().animation_finished.connect(_animation_finished)


func _enter() -> void:
	#get_hsm().label.text = "Left Punch"
	var left_punch := get_sub_state(^"LeftPunch")
	change_sub_state(left_punch)


func _update(_delta: float) -> void:
	var hsm := get_hsm() as StateMachine
	get_friction(10.25)
	
	move_and_slide()

	if _anim_finished:
		hsm.revert()


#func _exit() -> void:
	#super()
#
#func _animation_finished(anim_name: StringName):
	#if is_active() and (anim_name in get_anim().get_animation_list()):
		#_anim_finished = true

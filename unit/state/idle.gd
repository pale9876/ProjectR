# unit/state/idle.gd
extends UnitState


var move_state: UnitState
var fall_state: UnitState

@onready var anim: AnimationPlayer = $AnimationPlayer


func _enter() -> void:
	#var unit := agent as Unit
	move_state = get_state(^"Move")
	fall_state = get_state(^"Fall")
	
	anim.play(&"idle")


func _update(_delta: float) -> void:
	var unit := _get_unit()
	
	unit.velocity.x = move_toward(unit.velocity.x, 0., 15.5)

	if !is_on_floor():
		_get_hsm().change_active_state(fall_state)


	move_and_slide()

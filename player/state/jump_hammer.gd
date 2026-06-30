extends PlayerState


var idle_state: PlayerState
var jump_state: PlayerState
var fall_state: PlayerState


func _guard() -> bool:
	if get_state_machine().get_active_state() in [jump_state, fall_state]:
		return true
	return false


func _enter_tree() -> void:
	init_action()


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")
	jump_state = get_state_machine().get_state(^"Jump")
	fall_state = get_state_machine().get_state(^"Fall")
	 


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	pass

# counter_attack.gd
extends PlayerState


func _guard() -> bool:
	var state_macine := get_state_machine()
	
	var idle_state := state_macine.get_state("Idle")
	var move_state := state_macine.get_state("Move")
	
	if state_macine.get_active_state() in [idle_state, move_state]:
		return true
	return false


func _enter_tree() -> void:
	init_action()


func _enter() -> void:
	pass

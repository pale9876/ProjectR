# counter_attack.gd
extends PlayerActive


@export var anim: AnimationPlayer


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
	
	var player := get_player()
	var hurtbox := player.get_hurtbox()
	
	hurtbox.state = hurtbox.COUNTER
	anim.play(&"ready")


func _update(delta: float) -> void:
	pass

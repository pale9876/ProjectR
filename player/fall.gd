extends PlayerState


var idle_state: LimboState
var move_state: LimboState


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")
	move_state = get_state_machine().get_state(^"Move")


func _update(delta: float) -> void:
	var player := get_player()
	
	if is_on_floor():
		if player.input_state.direction.x != 0.:
			get_hsm().change_active_state(move_state)
		else:
			get_hsm().change_active_state(idle_state)
	
	player.velocity.x = move_toward(player.velocity.x, player.input_state.direction.x * 350., 15.)
	player.velocity.y = move_toward(player.velocity.y, 3100., 17.5)
	
	move_and_slide()

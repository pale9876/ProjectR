extends PlayerState


# state
@export var move_state: LimboState
@export var fall_state: LimboState
@export var jump_state: LimboState


func _enter() -> void:
	get_player().sprite_component.play(&"idle")


func _update(_delta: float) -> void:
	var player := get_player()
	var hsm := get_hsm()

	if Input.is_action_just_pressed("jump"):
		player.velocity.y = -450.

	if !is_on_floor():
		if player.velocity.y >= 0.:
			hsm.change_active_state(fall_state)
		elif player.velocity.y < 0.:
			hsm.change_active_state(jump_state)
	
	if absf(player.input_state.direction.x) > .3:
		hsm.change_active_state(move_state)
	
	player.velocity.x = move_toward(player.velocity.x, 0., 25.)
	move_and_slide()

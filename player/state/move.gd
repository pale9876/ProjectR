extends PlayerState


# state
@export var idle_state: LimboState
@export var fall_state: LimboState
@export var jump_state: LimboState
@export var slide_state: LimboState



func _update(_delta: float) -> void:
	var player := get_player()

	if Input.is_action_just_pressed(&"jump"):
		player.velocity.y = -450.
	
	
	player.velocity.x = move_toward(
		player.velocity.x, player.input_state.direction.x * 350., 35.
	)
	
	move_and_slide()
	
	if !is_on_floor():
		if player.velocity.y > 0.:
			get_hsm().change_active_state(fall_state)
			return
		elif player.velocity.y < 0.:
			get_hsm().change_active_state(jump_state)
			return
	
	if player.input_state.direction.x == 0.:
		get_hsm().change_active_state(idle_state)
	

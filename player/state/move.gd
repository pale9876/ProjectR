# player/state/move.gd
extends PlayerState


# state
var idle_state: LimboState
var fall_state: LimboState
var jump_state: LimboState
var slide_state: LimboState


func _ready() -> void:
	var state_machine := get_state_machine()
	
	idle_state = state_machine.get_state(^"Idle")
	jump_state = state_machine.get_state(^"Jump")
	slide_state = state_machine.get_state(^"Slide")
	fall_state = state_machine.get_state(^"Fall")


func _enter() -> void:
	var player := get_player()
	player.sprite_component.play(&"move")
	player.state.face = player.input_state.direction.round()


func _update(_delta: float) -> void:
	var player := get_player()
	var hsm := get_hsm()

	player.velocity.x = move_toward(
		player.velocity.x, player.input_state.direction.x * 350., 35.
	)


	move_and_slide()

	if Input.is_action_just_pressed(&"jump"):
		player.velocity.y = -450.
		hsm.change_active_state(jump_state)
		return

	if !is_on_floor():
		hsm.change_active_state(fall_state)
		return
	else:
		if player.state.face.x != player.input_state.direction.x:
			player.state.face.x = int(player.input_state.direction.x)
		
		if player.input_state.direction.x == 0.:
			hsm.change_active_state(idle_state)

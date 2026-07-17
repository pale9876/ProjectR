extends PlayerState


# state
var move_state: LimboState
var fall_state: LimboState
var jump_state: LimboState


func _enter_tree() -> void:
	add_library()


func _ready() -> void:
	move_state = get_state(^"Move")
	fall_state = get_state(^"Fall")
	jump_state = get_state(^"Jump")


func _enter() -> void:
	play(&"idle")


func _update(_delta: float) -> void:
	var player := get_player()
	var hsm := get_hsm()

	player.velocity.x = move_toward(player.velocity.x, 0., 25.)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = -450.
		change_state(jump_state)
		return

	if absf(player.get_input_direction().x) > .3:
		hsm.change_active_state(move_state)
		return

	if !is_on_floor():
		hsm.change_active_state(fall_state)
		return
	

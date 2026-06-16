extends PlayerState


# state
@export var idle_state: LimboState
@export var fall_state: LimboState
@export var jump_state: LimboState
@export var slide_state: LimboState


var slide_trigger: SkillTrigger = SkillTrigger.new(
	["down", "attack"]
)


func _update(_delta: float) -> void:
	var player := get_player()

	if Input.is_action_just_pressed(&"jump"):
		player.velocity.y = -450.

	player.velocity.x = move_toward(
		player.velocity.x, player.input_state.direction.x * 350., 35.
	)
	
	move_and_slide()
	
	var hsm := get_hsm()
	
	if !is_on_floor():
		if player.velocity.y > 0.:
			hsm.change_active_state(fall_state)
			return
		elif player.velocity.y < 0.:
			hsm.change_active_state(jump_state)
			return
	else:
		if player.input_state.direction.x == 0.:
			hsm.change_active_state(idle_state)
		else:
			if slide_trigger.spend():
				player.velocity.x = player.input_state.direction.x * 525.5
				hsm.change_active_state(slide_state)

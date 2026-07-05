extends PlayerActive


enum {
	LEFT,
	RIGHT,
	HAMMER,
}


var state: int = LEFT


func _ready() -> void:
	get_anim().animation_finished.connect(_animation_finished)


func _enter() -> void:
	var player := get_player()
	
	play(&"left_punch")
	get_hsm().label.text = "Left Punch"


func _update(_delta: float) -> void:
	var hsm := get_hsm() as StateMachine
	get_friction(10.25)
	
	move_and_slide()

	match state:
		LEFT:
			var left_punch_hit: bool = hitbox.is_hit(^"Left")
			
			if _punched and left_punch_hit:
				play(&"right_punch")
				state = RIGHT
				hitbox.get_hitshape(^"Left").disabled = true
				_anim_finished = false
				_punched = false
				hsm.label.text = "Right Punch"
				return
		RIGHT:
			var right_punch_hit: bool = hitbox.is_hit(^"Right")
			
			if _punched and right_punch_hit:
				if _just:
					play(&"hammer_ex")
					hsm.label.text = "Hammer EX"
					_just = false
				else:
					play(&"hammer")
					hsm.label.text = "Hammer"
				state = HAMMER
				hitbox.get_hitshape(^"Right").disabled = true
				_anim_finished = false
				_punched = false
				return


	if _anim_finished:
		hsm.revert()


func _exit() -> void:
	super()
	state = LEFT



func _animation_finished(anim_name: StringName):
	if is_active() and (anim_name in get_anim().get_animation_list()):
		_anim_finished = true

extends PlayerState


enum {
	LEFT,
	RIGHT,
	HAMMER,
}

@export var idle_state: LimboState
@export var move_state: LimboState
@export var just_frame: bool = false
@export var anim_postpone: int = 3


var state: int = LEFT
var _postpone: int = -1

var _anim_finished: bool = false
var _pressed: bool = false


@onready var anim: AnimationPlayer = $AnimationPlayer
@export var punch_combo_hitbox: PlayerHitbox


func _ready() -> void:
	var hsm := get_parent() as LimboHSM
	
	hsm.add_transition(
		hsm.ANYSTATE, self, &"high_punch",
		func() -> bool:
			if hsm.get_active_state() in [idle_state, move_state]:
				return true
			return false
	)
	
	anim.animation_finished.connect(_animation_finished)


func _enter() -> void:
	var player := get_player()
	
	anim.play(&"left_punch")
	_postpone = anim_postpone
	punch_combo_hitbox.scale.x = player.state.face.x


func _update(_delta: float) -> void:
	if _postpone == 0:
		get_hsm().change_active_state(idle_state)
	
	match state:
		LEFT:
			if Input.is_action_just_pressed(&"attack"):
				_pressed = true
				anim.play(&"right_punch")
				state = RIGHT
				_anim_finished = false
		RIGHT:
			if Input.is_action_just_pressed(&"attack"):
				if just_frame:
					anim.play(&"hammer_explosion")
				else:
					anim.play(&"hammer")
					get_player().sprite.play(&"hammer")
				_anim_finished = false
				state = HAMMER
	
	if _anim_finished:
		_postpone -= 1


func _exit() -> void:
	punch_combo_hitbox.clear()
	state = LEFT
	_anim_finished = false


func _animation_finished(anim_name: StringName):
	if is_active() and (anim_name in anim.get_animation_list()):
		_anim_finished = true
		if anim_name in [&"right_punch", &"left_punch", &"hammer", &"hammer_explosion"]:
			get_hsm().change_active_state(idle_state)

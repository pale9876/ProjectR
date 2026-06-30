extends PlayerState


enum {
	LEFT,
	RIGHT,
	HAMMER,
}


@export var just_frame: bool = false
@export var anim_postpone: int = 3


var state: int = LEFT
var _postpone: int = -1


var idle_state: LimboState
var move_state: LimboState
var block_state: LimboState

var _anim_finished: bool = false
var _pressed: bool = false
var _just: bool = true


@onready var anim: AnimationPlayer = $AnimationPlayer
@export var punch_combo_hitbox: PlayerHitbox


func _guard() -> bool:
	if get_state_machine().get_active_state() in [idle_state, move_state]:
		return true
	return false


func _enter_tree() -> void:
	init_action()


func _ready() -> void:
	anim.animation_finished.connect(_animation_finished)
	
	idle_state = get_state_machine().get_state(^"Idle")
	move_state = get_state_machine().get_state(^"Move")
	block_state = get_state_machine().get_state(^"Block")


func _enter() -> void:
	var player := get_player()
	
	anim.play(&"left_punch")
	punch_combo_hitbox.scale.x = player.state.face.x
	get_hsm().label.text = "Left Punch"


func _update(_delta: float) -> void:
	var player := get_player()
	
	player.velocity.x = move_toward(player.velocity.x, 0., 15.)
	move_and_slide()
	
	match state:
		LEFT:
			if _postpone > 0 and Input.is_action_just_pressed(&"attack"):
				_pressed = true
			
			if _pressed and _anim_finished:
				anim.play(&"right_punch")
				state = RIGHT
				_anim_finished = false
				_pressed = false
				get_hsm().label.text = "Right Punch"
		RIGHT:
			if _postpone > 0 and Input.is_action_just_pressed(&"attack"):
				_pressed = true
				if just_frame:
					_just = true
			
			if _pressed and _anim_finished:
				if _just:
					anim.play(&"hammer_explosion")
					get_hsm().label.text = "Hammer EX"
					_just = false
				else:
					anim.play(&"hammer")
					get_hsm().label.text = "Hammer"
				state = HAMMER
				_anim_finished = false
				_pressed = false


	if _anim_finished:
		_postpone -= 1
		if _postpone == 0:
			get_hsm().change_active_state(idle_state)


func _exit() -> void:
	_clear()


func _clear() -> void:
	punch_combo_hitbox.clear()
	state = LEFT
	_anim_finished = false
	_just = false


func _propel(motion: Vector2) -> void:
	var player := get_player()
	player.velocity.x += motion.x * player.state.face.x


func _animation_finished(anim_name: StringName):
	if is_active() and (anim_name in anim.get_animation_list()):
		_anim_finished = true
		_postpone = anim_postpone

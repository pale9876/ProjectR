extends PlayerState


enum {
	LEFT,
	RIGHT,
	HAMMER,
}


@export var just_frame: bool = false

@onready var punch_combo_hitbox: PlayerHitbox = $PunchCombo


var state: int = LEFT
var postpone: int = 4
var _just: int = 3
var _pressed: bool = false


@onready var anim: AnimationPlayer = $AnimationPlayer


func _enter() -> void:
	anim.play(&"left_punch")



func _update(delta: float) -> void:
	if Input.is_action_just_pressed(&"attack"):
		pass
	
	
	postpone -= 1
	_just -= 1



func _exit() -> void:
	punch_combo_hitbox.clear()
	state = LEFT
	postpone = 4
	_just = 3

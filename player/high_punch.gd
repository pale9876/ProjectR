extends PlayerState


enum {
	LEFT,
	RIGHT,
	HAMMER,
}


@export var anim: AnimationPlayer

@export var hitbox_shape_lp: HitboxShape
@export var hitbox_shape_rp: HitboxShape
@export var hitbox_shape_hammer: HitboxShape

@onready var punch_combo_hitbox: PlayerHitbox = $PunchCombo


var state: int = LEFT
var postpone: int = 4
var _just: int = 3



func _enter() -> void:
	pass



func _update(delta: float) -> void:
	pass


func _exit() -> void:
	punch_combo_hitbox.clear()
	state = LEFT
	postpone = 4
	_just = 3

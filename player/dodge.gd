# player/state/Dodge.gd
extends PlayerState


const Hurtbox: Script = preload("uid://er84buu2gymf")


@export var hurtbox: Hurtbox
@export var just_time: bool = false
@export var slow_duration: float = .45


@onready var anim: AnimationPlayer = $AnimationPlayer


var _success: bool = false


func _ready() -> void:
	hurtbox.dodge.connect(
		_on_dodge_successed
	)


func _enter() -> void:
	hurtbox.state = Hurtbox.DODGE
	anim.play(&"dodge")


func _exit() -> void:
	_success = false
	hurtbox.state = Hurtbox.IDLE


func _update(delta: float) -> void:
	if _success:
		EventHorizon.player_dodged_ev(slow_duration)
		_success = false


func _on_dodge_successed() -> void:
	_success = true

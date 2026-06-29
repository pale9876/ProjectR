# player/state/Dodge.gd
extends PlayerState


@export var just_time: bool = false
@export var slow_duration: float = .45

@onready var anim: AnimationPlayer = $AnimationPlayer


var _success: bool = false


func _ready() -> void:
	var player := get_state_machine().get_player()
	anim.animation_finished.connect(_on_dodge_anim_finsiehd)
	player.get_hurtbox().dodge.connect(_on_dodge_successed)


func _enter() -> void:
	var hurtbox := get_player().get_hurtbox()
	hurtbox.state = hurtbox.DODGE
	
	anim.play(&"dodge")


func _exit() -> void:
	var hurtbox := get_player().get_hurtbox()
	hurtbox.state = hurtbox.IDLE
	
	_success = false


func _update(delta: float) -> void:
	if _success:
		if just_time:
			EventHorizon.player_dodged_ev(slow_duration)
		_success = false


func _on_dodge_successed() -> void:
	_success = true


func _on_dodge_anim_finsiehd(anim_name: StringName) -> void:
	if anim_name == &"dodge":
		get_hsm().revert()

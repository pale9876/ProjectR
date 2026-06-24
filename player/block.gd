# guard.gd
extends PlayerState



@onready var anim: AnimationPlayer = $AnimationPlayer


var idle_state: PlayerState
var move_state: PlayerState

@export var _just: bool = false


func _clear() -> void:
	_just = false


func _guard() -> bool:
	var hsm := get_hsm()
	var player := get_player()
	
	if (hsm.get_active_state() as PlayerState).block_cancel:
		return true
	
	return false


func _ready() -> void:
	var hsm := get_hsm()
	
	idle_state = hsm.get_state("Idle")
	move_state = hsm.get_state("Move")


func _enter() -> void:
	anim.play(&"guard_on")


func _update(_delta: float) -> void:
	var player := get_player()
	player.velocity.x = move_toward(player.velocity.x, 0., 15.5)


func _exit() -> void:
	_clear()

#player/state/hurt.gd
extends PlayerState


# Import
const HurtEv: Script = preload("uid://cpbogpcwj4utb")


# Consts
const NONE := HurtEv.NONE
const KNOCKBACK := HurtEv.KNOCKBACK
const AERIAL := HurtEv.AERIAL
const PUSHBACK := HurtEv.PUSHBACK


# States
var idle_state: PlayerState
var fall_state: PlayerState
var jump_state: PlayerState


var _state := NONE
var damage_frame: int = 0

var _motion: Vector2 = Vector2()


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")
	fall_state = get_state_machine().get_state(^"Fall")
	jump_state = get_state_machine().get_state(^"Jump")


func _enter() -> void:
	pass


func _update(delta: float) -> void:
	var player := get_player()
	
	match _state:
		KNOCKBACK:
			_motion.x = move_toward(_motion.x, 0., 7.25)
			player.velocity = _motion
			
			move_and_slide()
			
			if is_on_wall():
				_motion.x = - _motion.x
			
			if !is_on_floor():
				_motion.y = move_toward(_motion.y, 970., 15.5)
				player.velocity = _motion

		AERIAL:
			player.velocity.y = move_toward(player.velocity.y, 970., 15.5)
			move_and_slide()

		PUSHBACK:
			player.velocity.y = move_toward(player.velocity.y, 450., 12.25)
			move_and_collide(player.velocity * delta)

	if damage_frame == 0:
		if !is_on_floor():
			get_hsm().change_active_state(fall_state)
			return
		
		get_hsm().change_active_state(idle_state)
		
	else:
		damage_frame -= 1
	
	


func _exit() -> void:
	_state = NONE
	_motion = Vector2()

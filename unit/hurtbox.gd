# unit/hurtbox.gd
extends Area2D


# Import
const StateMachine: Script = preload("uid://dcybwuwfqeqr3")
const HurtState: Script = preload("uid://btf7rckikcpps")

# Const
const NONE := HurtEV.MotionState.NONE
const KNOCKBACK := HurtEV.MotionState.KNOCKBACK
const AERIAL := HurtEV.MotionState.AERIAL
const PUSHBACK := HurtEV.MotionState.PUSHBACK
const DOWNED := HurtEV.MotionState.DOWNED


enum State {
	IDLE,
	EXPOSE,
	COUNTER,
	BLOCK,
	DODGE,
}


const IDLE := State.IDLE
const EXPOSE := State.EXPOSE
const COUNTER := State.COUNTER
const BLOCK := State.BLOCK
const DODGE := State.DODGE


signal blocked()
signal dodged()
signal counter()


@export var state: State = State.IDLE

var invincible_frame: int:
	set(value):
		invincible_frame = maxi(value, 0)
var is_invincible: bool:
	get:
		return invincible_frame > 0


func _init() -> void:
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(1, true)


func _physics_process(_delta: float) -> void:
	if invincible_frame > 0:
		invincible_frame -= 1


func damaged(hitbox_info: HitboxInformation, hit_result: HitResult) -> void:
	var unit: Unit = get_parent() as Unit
	var atk_type := hitbox_info.type
	
	if !has_dodged() and !blocked_attack(hitbox_info, hit_result) and effective(hitbox_info):
		var state_machine := unit.hsm
		var hurt_state := unit.hsm.get_state(^"Hurt") as HurtState
		
		match atk_type:
			HitboxInformation.Type.KNOCKBACK:
				hurt_state.set_state(KNOCKBACK)
			HitboxInformation.Type.AERIAL:
				hurt_state.set_state(AERIAL)
		
		hurt_state.damage_frame = hitbox_info.damage_frame
		hurt_state.motion = hitbox_info.force
		unit.stat.hp -= hitbox_info.damage
		
		state_machine.change_active_state(hurt_state)



func effective(info: HitboxInformation) -> bool:
	match state:
		IDLE:
			return true
		EXPOSE:
			info.damage = int(info.damage * 1.35)
			return true
		COUNTER:
			counter.emit()
			return false
		DODGE:
			dodged.emit()
			return false
	
	return false



func has_dodged() -> bool:
	if state == DODGE:
		return true
	
	return false


func blocked_attack(info: HitboxInformation, result: HitResult) -> bool:
	var unit := get_parent() as Unit
	var attack_direction: float = ceili(result.from.global_position.direction_to(result.to.global_position).x)
	var unit_face: float = ceili(float((get_parent() as Unit).state.face.x))
	var damage: int = info.damage
	
	if state == BLOCK and attack_direction != unit_face:
		damage = int(info.damage * .25)
		unit.stat.hp -= damage
		blocked.emit()
		return true
	
	return false

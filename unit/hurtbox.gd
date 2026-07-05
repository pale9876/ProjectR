# unit/hurtbox.gd
extends Area2D


# Import
const StateMachine: Script = preload("uid://dcybwuwfqeqr3")
const Player: Script = preload("uid://c2uxhumgng18h")

const KnockbackState: Script = preload("uid://b1m4oejiu7ume")
const AerialState: Script = preload("uid://dsjnx0cxf2gu1")
const PushbackState: Script = preload("uid://8rj1txp84awx")
const WallhitState: Script = preload("uid://cqhhjr6ob8477")
const GrabbedState: Script = preload("uid://6eubdpqc1rif")
const DownState = preload("uid://cattor5p0ysjp")



# Const
const NONE := HurtEV.MotionState.NONE
const KNOCKBACK := HurtEV.MotionState.KNOCKBACK
const AERIAL := HurtEV.MotionState.AERIAL
const PUSHBACK := HurtEV.MotionState.PUSHBACK
const DOWNED := HurtEV.MotionState.DOWNED


enum State {
	IDLE,
	EXPOSE,
	HURT,
	COUNTER,
	BLOCK,
	DODGE,
}


const IDLE := State.IDLE
const EXPOSE := State.EXPOSE
const COUNTER := State.COUNTER
const HURT := State.HURT
const BLOCK := State.BLOCK
const DODGE := State.DODGE


signal blocked()
signal dodged()
signal counter()


@export var state: State = State.IDLE


var invincible_frame: int:
	set(value):
		invincible_frame = maxi(value, 0)

var is_invincible: bool = false


func _init() -> void:
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(1, true)


func _physics_process(_delta: float) -> void:
	if invincible_frame > 0:
		invincible_frame -= 1


func damaged(hitbox_info: HitboxInformation, hit_result: HitResult) -> void:
	if is_invincible: return
	
	if !has_dodged() and !blocked_attack(hitbox_info, hit_result) and effective():
		set_hurt_state(hitbox_info, hit_result)


func set_hurt_state(hitbox_info: HitboxInformation, hit_result: HitResult) -> void:
	var state_machine := (get_parent() as Unit).hsm
	var current_state := state_machine.get_active_state() as UnitState
	var next_state: UnitState = null
	
	if !current_state in get_hurt_states():
		match hitbox_info.type:
			HitboxInformation.KNOCKBACK:
				next_state = get_knockback_state()
			HitboxInformation.AERIAL:
				next_state = get_aerial_state()
			HitboxInformation.PUSHBACK:
				next_state = get_pushback_state()
			HitboxInformation.POUND:
				next_state = get_pound_state()
		state_machine.init_hurt_state(hitbox_info, hit_result, next_state)
	else:
		current_state.event(hitbox_info, hit_result)


func get_hurt_states() -> Array[UnitState]:
	return [
		get_knockback_state(),
		get_aerial_state(),
		get_pushback_state(),
		get_wallhit_state(),
		get_down_state(),
	]


func get_pound_state() -> UnitState:
	return (get_parent() as Unit).hsm.get_state(^"Pound")


func get_knockback_state() -> KnockbackState:
	return (get_parent() as Unit).hsm.get_state(^"Knockback") as KnockbackState


func get_aerial_state() -> AerialState:
	return (get_parent() as Unit).hsm.get_state(^"Aerial") as AerialState


func get_pushback_state() -> PushbackState:
	return (get_parent() as Unit).hsm.get_state(^"Pushback") as PushbackState


func get_wallhit_state() -> WallhitState:
	return (get_parent() as Unit).hsm.get_state(^"Wallhit") as WallhitState


func get_down_state() -> DownState:
	return (get_parent() as Unit).hsm.get_state(^"Down") as DownState



func effective() -> bool:
	if state in [IDLE, EXPOSE, HURT]: return true
	
	return false


func has_dodged() -> bool:
	if state == DODGE:
		dodged.emit()
		return true
	
	return false


func parried() -> bool:
	if state == COUNTER:
		counter.emit()
		return true
	return false


func blocked_attack(info: HitboxInformation, result: HitResult) -> bool:
	var unit := get_parent() as Unit
	var attack_direction: float = ceili(
		result.from.global_position.direction_to(result.to.global_position).x
	)
	var unit_face: float = ceili(float((get_parent() as Unit).state.face.x))
	var damage: int = info.damage
	
	if state == BLOCK and attack_direction != unit_face:
		damage = int(info.damage * .25)
		unit.stat.hp -= damage
		blocked.emit()
		return true
	
	return false


func check_collide(to: Node2D) -> bool:
	var unit := get_parent() as Unit
	var param := PhysicsRayQueryParameters2D.create(
		unit.global_position, to.global_position
	)
	
	param.collision_mask = 1
	param.exclude = [unit.get_rid()]
	
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	
	if !result.is_empty():
		var collider: Object = result["collider"]
		if collider is StaticBody2D:
			return false
	
	return true


	

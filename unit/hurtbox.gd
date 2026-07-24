extends Area2D
class_name Hurtbox


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


enum Econ {
	IDLE,
	EXPOSE,
	HURT,
	COUNTER,
	BLOCK,
	DODGE,
}


# Const (HurtEV)
const NONE := HurtEV.MotionState.NONE
const KNOCKBACK := HurtEV.MotionState.KNOCKBACK
const AERIAL := HurtEV.MotionState.AERIAL
const PUSHBACK := HurtEV.MotionState.PUSHBACK
const DOWNED := HurtEV.MotionState.DOWNED


# Const (Econ)
const IDLE := Econ.IDLE
const EXPOSE := Econ.EXPOSE
const COUNTER := Econ.COUNTER
const HURT := Econ.HURT
const BLOCK := Econ.BLOCK
const DODGE := Econ.DODGE


signal blocked()
signal dodged()
signal counter()


@export var state: Econ = IDLE
@export var invincible: bool = false


var invincible_frame: int:
	set(value):
		invincible_frame = maxi(value, 0)

var is_invincible: bool:
	get:
		return invincible_frame > 0 or invincible


func _init() -> void:
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(2, true)


func _enter_tree() -> void:
	owner = get_parent() as Replicator


func _physics_process(_delta: float) -> void:
	if invincible_frame > 0:
		invincible_frame -= 1


func get_unit() -> Replicator:
	return get_parent() as Replicator


func damaged(hitbox_info: HitboxInformation, hit_result: HitResult) -> void:
	if is_invincible: return
	
	var unit := get_unit()
	
	if !has_dodged() and !blocked_attack(hitbox_info, hit_result) and effective():
		set_hurt_state(hitbox_info, hit_result)
		if hit_result.from is Player:
			EventHorizon.hit(hitbox_info)
		


func set_hurt_state(hitbox_info: HitboxInformation, hit_result: HitResult) -> void:
	var state_machine := (get_parent() as Unit).get_state_machine()
	var current_state := state_machine.get_active_state() as UnitState
	var next_state: NodePath = ^""
	
	if !current_state.name in get_hurt_states():
		next_state = get_state_from_type(hitbox_info.type)
		state_machine.init_hurt_state(hitbox_info, hit_result, next_state)
	else:
		current_state.event(hitbox_info, hit_result)


func get_state_from_type(type: HitboxInformation.Type) -> NodePath:
	var result: NodePath
	match type:
		HitboxInformation.KNOCKBACK:
			result = ^"Knockback"
		HitboxInformation.AERIAL:
			result = ^"Aerial"
		HitboxInformation.PUSHBACK:
			result = ^"Pushback"
		HitboxInformation.POUND:
			result = ^"Pound"
	return result


func get_hurt_states() -> Array[StringName]:
	return [
		&"Knockback",
		&"Aerial",
		&"Pushback",
		&"Wallhit",
		&"Pound",
		&"Grabbed",
		&"Down",
	]


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


	

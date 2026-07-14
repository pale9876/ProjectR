extends CharacterBody2D
class_name Replicator


# Import
const SpriteComponent: Script = preload("uid://b0paoljcmbiys")
const SpriteModuler: Script = preload("uid://dbcsuysfwo30x")
const StateMachine: Script = preload("uid://nmmtety5yvve")


@export var z_value: float = 0.


var stat: Stat = Stat.new()
var state: State = State.new()


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)


func soft_pause() -> void:
	set_process(false)
	set_physics_process(false)
	InputState.lock()


func resume() -> void:
	set_process(true)
	set_physics_process(true)
	InputState.unlock()


func get_hitbox_component() -> HitboxComponent:
	return get_node(^"HitboxComponent") as HitboxComponent


func get_sprite_component() -> SpriteComponent:
	return get_node(^"SpriteComponent") as SpriteComponent


func get_state_machine() -> LimboHSM:
	return get_node(^"StateMachine")


func get_sprite() -> AnimatedSprite2D:
	return get_sprite_component().sprite


func get_moduler() -> SpriteModuler:
	return get_sprite_component().moduler


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox") as Hurtbox


func get_collider() -> CollisionShape2D:
	return get_node(^"UnitCollision") as CollisionShape2D


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer") as AnimationPlayer


func get_stage() -> Stage:
	return get_parent() as Stage


class State:
	signal face_changed()
	
	var face: Vector2i = Vector2i.RIGHT:
		set(value):
			if value != face:
				face = value if value.x != 0. else Vector2i(face.x, value.y)
				face_changed.emit()
	var direction: Vector2 = Vector2():
		set(value):
			if direction != value:
				direction = value

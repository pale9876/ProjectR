# player.gd
extends CharacterBody2D


# Import
const SpriteComponent: Script = preload("uid://b0paoljcmbiys")
const SpriteModuler: Script = preload("uid://dbcsuysfwo30x")
const Hurtbox: Script = preload("uid://er84buu2gymf")
const PlayerCamera: Script = preload("uid://b7phyhue4y3yg")
const StateMachine: Script = preload("uid://nmmtety5yvve")


@export_category("NodePath")
@export var animation_player: NodePath

@export_category("Data")
@export var info: PlayerInformation
@export var z_value: float = 0.


var stat: Stat = Stat.new()
var state: State = State.new()
var input_state: InputState


@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var drop_shadow: Sprite2D = $DropShadow
@onready var hsm: StateMachine = $StateMachine


var _prefix: StringName = &""


func get_stat() -> Stat:
	return stat


func _init() -> void:
	input_state = InputState
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)

	state.face_changed.connect(_on_face_changed)


func _on_face_changed() -> void:
	if state.face.x != 0:
		sprite_component.scale.x = state.face.x


func _enter_tree() -> void:
	GSignal.soft_pause.connect(_soft_pause)
	GSignal.resume.connect(_resume)


func _ready() -> void:
	if info:
		stat.name = name
		stat.hp = info.hp
		stat.speed = info.speed
		
		sprite_component.init_sprites(
			info.upper_sprite,
			info.lower_sprite,
			info.sprite
		)

	var idle_state := hsm.get_state(^"Idle")
	hsm.initial_state = idle_state
	hsm.initialize(self)
	hsm.set_active(true)


func get_face() -> float:
	return float(state.face.x)


func _process(_delta: float) -> void:
	# Input
	input_state.direction = Input.get_vector("left", "right", "up", "down")
	
	# Shadow
	var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position,
		Vector2(global_position.x, global_position.y + 3000.),
		1, [get_rid()]
	)
	
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	
	if !result.is_empty():
		var intersect_point := result["position"] as Vector2
		var scale_progress: float = global_position.distance_to(intersect_point) / 3000.
		drop_shadow.scale = Vector2((1. - scale_progress), (1. - scale_progress))
		drop_shadow.global_position = intersect_point


func _soft_pause() -> void:
	set_process(false)
	set_physics_process(false)
	InputState.lock()


func _resume() -> void:
	set_process(true)
	set_physics_process(true)
	InputState.unlock()


func get_hitbox_component() -> HitboxComponent:
	return get_node(^"HitboxComponent") as HitboxComponent


func get_state_machine() -> LimboHSM:
	return get_node(^"StateMachine")


func get_sprite() -> AnimatedSprite2D:
	return sprite_component.sprite


func get_moduler() -> SpriteModuler:
	return sprite_component.moduler


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox") as Hurtbox


func get_collider() -> CollisionShape2D:
	return get_node(^"UnitCollision") as CollisionShape2D


func get_camera() -> PlayerCamera:
	return Global.player_camera


func get_anim() -> AnimationPlayer:
	return get_node(animation_player) as AnimationPlayer


func get_stage() -> Stage:
	return get_parent() as Stage


class State:
	signal face_changed()
	
	var face: Vector2i = Vector2i.RIGHT:
		set(value):
			if value != face:
				face = value if value.x != 0. else Vector2i(face.x, value.y)
				face_changed.emit()
	var mouse_direction: Vector2 = Vector2():
		set(value):
			if mouse_direction != value:
				mouse_direction = value

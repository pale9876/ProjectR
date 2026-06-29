# player.gd
extends CharacterBody2D


# Import
const SpriteComponent: Script = preload("uid://b0paoljcmbiys")
const SpriteModuler: Script = preload("uid://dbcsuysfwo30x")
const Hurtbox: Script = preload("uid://er84buu2gymf")
const PlayerCamera: Script = preload("uid://b7phyhue4y3yg")
const HitboxComponent: Script = preload("uid://dr8n2mbhooxjo")



@export var info: PlayerInformation
@export var hsm: LimboHSM
@export var z_value: float = 0.


var input_state: InputState = InputState.new()
var stat: Stat = Stat.new()
var state: State = State.new()


@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var drop_shadow: Sprite2D = $DropShadow


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	
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

	hsm.initialize(self)
	hsm.set_active(true)

	input_state.unlock()


func get_face() -> float:
	return state.face.x



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
	input_state.lock()


func _resume() -> void:
	set_process(true)
	set_physics_process(true)
	input_state.unlock()


func get_sprite() -> AnimatedSprite2D:
	return sprite_component.sprite


func get_moduler() -> SpriteModuler:
	return sprite_component.moduler


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox") as Hurtbox


func get_camera() -> PlayerCamera:
	return get_node(^"Camera2D") as PlayerCamera



class Stat:
	signal damaged()
	signal dead()
	
	var name: StringName = &""
	var level: int = 0
	var hp: int
	var max_hp: int
	var speed: float
	var position: Vector2


class State:
	signal face_changed()
	
	var face: Vector2i = Vector2i.RIGHT:
		set(value):
			if value != face:
				face = value if value.x != 0. else Vector2i(face.x, value.y)
				face_changed.emit()
	var mouse_direction: Vector2 = Vector2()


class InputState:
	var direction: Vector2 = Vector2.ZERO:
		set(value):
			if !_lock:
				direction = value
	var reserve_action: String
	var order_duration: float = - 1.
	var _duration: float = 0.
	var _lock: bool = false


	func lock() -> void:
		_lock = true


	func unlock() -> void:
		_lock = false

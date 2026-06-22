# player.gd
extends CharacterBody2D


@export var info: PlayerInformation
@export var hsm: LimboHSM
@export var z_value: float = 0.


var prefix: StringName = &"_down"

var input_state: InputState = InputState.new()
var stat: Stat = Stat.new()
var state: State = State.new()


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var drop_shadow: Sprite2D = $DropShadow


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)

	state.face_changed.connect(_on_face_changed)


func _on_face_changed() -> void:
	if state.face.x > 0.:
		sprite.flip_h = false
	elif state.face.x < 0.:
		sprite.flip_h = true


func _enter_tree() -> void:
	GSignal.soft_pause.connect(_soft_pause)
	GSignal.resume.connect(_resume)


func _ready() -> void:
	if info:
		stat.name = name
		stat.hp = info.hp
		stat.speed = info.speed
	
		stat._update()

	if info:
		sprite.sprite_frames = info.sprite

	hsm.initialize(self)
	hsm.set_active(true)

	input_state.unlock()



func _process(delta: float) -> void:
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


func _physics_process(_delta: float) -> void:
	input_state.direction = Input.get_vector("left", "right", "up", "down")
	


func _soft_pause() -> void:
	set_process(false)
	set_physics_process(false)
	input_state.lock()


func _resume() -> void:
	set_process(true)
	set_physics_process(true)
	input_state.unlock()


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

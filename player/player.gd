# player.gd
extends CharacterBody2D





@export var info: PlayerInformation
@export var hsm: LimboHSM
@export var z_value: float = 0.

var prefix: StringName = &"_down"
var action: StringName = &"idle"


var input_state: InputState = InputState.new()
var stat: Stat = Stat.new()
var state: State = State.new()


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var drop_shadow: Sprite2D = $DropShadow


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, false)


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

	func _update() -> void:
		if Global.data != null:
			Global.data["name"] = name
			Global.data["speed"] = speed
			Global.data["position"] = position


class State:
	var face: Vector2i = Vector2i.DOWN:
		set(value):
			if value != face:
				face = value
				if !on_face_changed.is_empty():
					for fn: Callable in on_face_changed:
						fn.call()
	var mouse_direction: Vector2 = Vector2()
	var on_face_changed: Array[Callable]


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

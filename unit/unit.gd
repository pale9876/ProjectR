extends CharacterBody2D
class_name Unit


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const SpriteComponent: Script = preload("uid://b0paoljcmbiys")
const Awareness: Script = preload("uid://bdj3moatwduju")
const StateMachine: Script = preload("uid://dcybwuwfqeqr3")
const Hurtbox: Script = preload("uid://bupj3hlvtt67s")


signal deactive()
signal active()



@export var info: UnitInformation
@export var z_value: float = 0.
@export var rage_mode: bool = true


@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var bt: BTPlayer = $BTPlayer
@onready var hsm: StateMachine = $LimboHSM
#@onready var agent: NavigationAgent2D = $NavigationAgent2D


var stat: Stat = Stat.new()
var state: State = State.new()


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer") as AnimationPlayer


func _on_face_changed() -> void:
	sprite_component.scale.x = float(state.face.x)


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)


func _enter_tree() -> void:
	GSignal.soft_pause.connect(_soft_paused)
	GSignal.resume.connect(_resume)
	
	# init hp
	stat.name = info.name
	stat.max_hp = info.hp
	stat.hp = stat.max_hp
	stat.speed = info.speed


func _ready() -> void:
	bt.active = false
	
	sprite_component.init_sprites(
		info.upper_motions,
		info.lower_motions,
		info.sprite_frames
	)
	
	hsm.initialize(self)
	hsm.set_active(true)


func _soft_paused() -> void:
	set_process(false)
	set_physics_process(false)


func _resume() -> void:
	set_process(false)
	set_physics_process(false)


func get_awareness_area() -> Awareness:
	return get_node(^"Awareness")


#func _ready() -> void:
	#agent.navigation_finished.connect(_agent_navigation_finished)
	#agent.velocity_computed.connect(_agent_velocity_computed)


func _agent_velocity_computed(_safe: Vector2) -> void:
	pass


func _agent_navigation_finished() -> void:
	pass


func _refresh_path() -> void:
	pass


func get_btbb() -> Blackboard:
	return bt.blackboard


func get_sprite() -> AnimatedSprite2D:
	return sprite_component.sprite


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox")


class Stat:
	var name: StringName
	var max_hp: int
	var hp: int:
		set(value):
			hp = clampi(value, 0, max_hp)
	var speed: float:
		set(value):
			speed = maxf(0., value)
	var is_dead: bool:
		get:
			return hp == 0

class State:
	signal face_changed()
	
	var face: Vector2i:
		set(value):
			face = value
			face_changed.emit()

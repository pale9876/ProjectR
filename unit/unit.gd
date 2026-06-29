extends CharacterBody2D
class_name Unit


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const SpriteComponent: Script = preload("uid://b0paoljcmbiys")
const Awareness: Script = preload("uid://bdj3moatwduju")


signal deactive()
signal active()


@export var info: UnitInformation
@export var z_value: float = 0.
@export var rage_mode: bool = true


@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var bt: BTPlayer = $BTPlayer
#@onready var agent: NavigationAgent2D = $NavigationAgent2D


var stat: Stat = Stat.new()
var state: State = State.new()


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


class Stat:
	var name: StringName
	var max_hp: int
	var hp: int:
		set(value):
			hp = clampi(value, 0, max_hp)
	var speed: float:
		set(value):
			speed = maxf(0., value)


class State:
	var face: Vector2
	var motion_direction: Vector2
	var target: Node2D

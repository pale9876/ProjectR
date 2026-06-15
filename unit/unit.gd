extends CharacterBody2D
class_name Unit


# Import
const Information: Script = preload("uid://c3ykemf4n3om1")
const Player: Script = preload("uid://c2uxhumgng18h")


@export var information: Information
@export var bt: BTPlayer


@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
#@onready var agent: NavigationAgent2D = $NavigationAgent2D


var stat: Stat = Stat.new()
var state: State = State.new()


func _enter_tree() -> void:
	GSignal.soft_pause.connect(_soft_paused)
	GSignal.resume.connect(_resume)
	
	# init hp
	stat.max_hp = information.hp
	stat.hp = stat.max_hp
	stat.speed = information.speed


func _soft_paused() -> void:
	set_process(false)
	set_physics_process(false)


func _resume() -> void:
	set_process(false)
	set_physics_process(false)


#func _ready() -> void:
	#agent.navigation_finished.connect(_agent_navigation_finished)
	#agent.velocity_computed.connect(_agent_velocity_computed)


func _agent_velocity_computed(_safe: Vector2) -> void:
	pass


func _agent_navigation_finished() -> void:
	pass


#func _physics_process(delta: float) -> void:
	#move_and_slide()

func _refresh_path() -> void:
	pass


func get_bb() -> Blackboard:
	return bt.blackboard


class Stat:
	var max_hp: int
	var hp: int
	var speed: float


class State:
	var face: Vector2
	var motion_direction: Vector2

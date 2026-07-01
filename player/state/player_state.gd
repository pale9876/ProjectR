extends LimboState
class_name PlayerState


enum Type {
	IDLE,
	JUMP,
}


const IDLE := Type.IDLE
const JUMP := Type.JUMP


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const StateMachine: Script = preload("uid://nmmtety5yvve")


# Conditions
@export var type: Type = IDLE
@export var action_input: PackedStringArray
@export var ev_name: StringName
@export var block_cancel: bool = false
@export var dodge_cancel: bool = false

@export_category("Animations")
@export var anim_library: AnimationLibrary
@export var library_name: StringName


## get_root()를 통하여 찾음.
func get_hsm() -> StateMachine:
	return get_root() as StateMachine


func get_anim() -> AnimationPlayer:
	return (get_state_machine().get_parent() as Player).get_anim()


func add_library() -> void:
	get_anim().add_animation_library(library_name, anim_library)


func create_library() -> void:
	get_anim().add_animation_library(library_name, AnimationLibrary.new())
	

func add_animation(anim_name: StringName, anim: Animation) -> void:
	get_anim().get_animation_library(library_name).add_animation(anim_name, anim)


func play(anim_name: StringName) -> void:
	get_anim().play(library_name + &"/" + anim_name)


func get_player() -> Player:
	return agent as Player


func is_on_floor() -> bool:
	return get_player().is_on_floor()


func move_and_slide() -> bool:
	return get_player().move_and_slide()


## 노드패스를 통해 찾음.
func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine


func move_and_collide(
	motion: Vector2, test: bool = false, margin: float = .08
	) -> KinematicCollision2D:
	
	return get_player().move_and_collide(motion, test, margin, false)


func is_on_wall() -> bool:
	return get_player().is_on_wall()



func init_action() -> void:
	assert(
		!action_input.is_empty() and !ev_name.is_empty(),
		"액션 인풋이 비어있거나, 디스패치 이벤트 이름이 존재하지 않음."
	)
		
	var state_machine := get_state_machine()
	state_machine.input_map[type][action_input] = ev_name
	state_machine.add_transition(
		state_machine.ANYSTATE, self, ev_name, _guard
	)


# OVERRIDE
func _guard() -> bool:
	return true


# OVERRIDE
func _clear() -> void:
	pass


func _lock() -> void:
	get_player().input_state.lock()


func _unlock() -> void:
	get_player().input_state.unlock()

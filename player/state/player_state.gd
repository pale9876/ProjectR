extends LimboState
class_name PlayerState


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const StateMachine: Script = preload("uid://nmmtety5yvve")

# Conditions
@export var action_input: PackedStringArray
@export var ev_name: StringName
@export var block_cancel: bool = false
@export var dodge_cancel: bool = false


func get_hsm() -> StateMachine:
	return get_root() as StateMachine


func get_player() -> Player:
	return agent as Player


func is_on_floor() -> bool:
	return get_player().is_on_floor()


func move_and_slide() -> bool:
	return get_player().move_and_slide()


func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine


func init_action() -> void:
	assert(
		!action_input.is_empty() and !ev_name.is_empty(),
		"액션 인풋이 비어있거나, 디스패치 이벤트 이름이 존재하지 않음."
	)
		
	var state_machine := get_state_machine()
	state_machine.input_map[action_input] = ev_name
	state_machine.add_transition(
		state_machine.ANYSTATE, self, ev_name, _guard
	)


# OVERRIDE
func _guard() -> bool:
	return true


# OVERRIDE
func _clear() -> void:
	pass


# OVERRIDE
func _propel(motion: Vector2) -> void:
	pass


func _lock() -> void:
	get_player().input_state.lock()


func _unlock() -> void:
	get_player().input_state.unlock()

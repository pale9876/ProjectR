# state_machine.gd
extends LimboHSM


# Global States
const Idle: Script = preload("uid://c08p61o8pw6vo")
const Move: Script = preload("uid://c4q85mvv6k6wb")
const Player: Script = preload("uid://c2uxhumgng18h")


# CONST EV
const EV_REVERT: StringName = &"revert"


@export var label: Label
@export var input_postpone: int = 3


var locked_frame: int = 0:
	set(value):
		locked_frame = maxi(value, 0)


# input_arr : ev_name
var input_map: Dictionary[PlayerState.Type, Dictionary] = {
	PlayerState.IDLE : {
		
	},
	PlayerState.JUMP : {
		
	},
}


func _ready() -> void:
	var idle_state := get_state(^"Idle")
	add_transition(ANYSTATE, idle_state, EV_REVERT)

	active_state_changed.connect(
		func(current: LimboState, _prev: LimboState) -> void:
			label.text = current.name
	)

func _physics_process(_delta: float) -> void:
	var state: PlayerState.Type = get_current_type()
	var input_cached := InputState.get_cached()
	
	if ("attack" in input_cached) or ("kick" in input_cached):
		if input_map[state].has(input_cached):
			dispatch(input_map[state][input_cached])
			#print("Dispatch => ", input_map[state][input_cache])
		InputState.clear()
		return

	if input_map[state].has(input_cached):
		dispatch(input_map[state][input_cached])
		InputState.clear()
		return

	var active_states := get_active_states()
	for active: PlayerActive in active_states:
		if !active.cooldowned():
			active.tick()


func get_current_type() -> PlayerState.Type:
	return current_state().type


func current_state() -> PlayerState:
	return get_active_state() as PlayerState


func get_active_states() -> Array[PlayerActive]:
	var result: Array[PlayerActive] = []
	var category: LimboState = get_node(^"#ActState")
	var start_idx: int = category.get_index() + 1
	var last_idx: int = get_children().size()
	
	result.resize(last_idx - start_idx)
	
	for i: int in range(last_idx - start_idx):
		result[i] = get_child(start_idx + i) as PlayerActive

	return result


func get_player() -> Player:
	return get_parent() as Player


func get_state(state_name: NodePath) -> PlayerState:
	return get_node(state_name) as PlayerState


func get_action_input_map_list() -> PackedStringArray:
	return input_map.keys()


func inputmap_clear() -> void:
	input_map = {
		PlayerState.IDLE : {
			# PackedStringArray() : StringName(ev_name)
		},
		PlayerState.JUMP : {
			# PackedStringArray() : StringName(ev_name)
		},
	}


func revert() -> void:
	dispatch(EV_REVERT)

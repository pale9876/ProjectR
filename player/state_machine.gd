# state_machine.gd
extends LimboHSM


# Import
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
	# Dictionary[PlayerState.Type, Dictionary[PackedStringArray, StringName]]
	PlayerState.IDLE : {
		
	},
	PlayerState.JUMP : {
		
	},
}


func type_has_input_action(type: PlayerState.Type, input_act: PackedStringArray) -> bool:
	return input_map[type].has(input_act)


func type_set_action(
	type: PlayerState.Type,
	input_act: PackedStringArray,
	_state: LimboState,
	ev: StringName,
	_guard: Callable
) -> void:
	if ev.is_empty():
		printerr("%s => 이벤트 이름이 비어 있습니다." % [_state.name])
		return
	
	input_map[type][input_act] = ev
	add_transition(ANYSTATE, _state, ev, _guard)



func _ready() -> void:
	var idle_state := get_state(^"Idle")
	add_transition(ANYSTATE, idle_state, EV_REVERT)

	active_state_changed.connect(
		func(current: LimboState, _prev: LimboState) -> void:
			label.text = current.name
	)


func get_states_from_category(category_path: NodePath) -> Array[LimboState]:
	assert(get_node(category_path) is CategoryComment)
	var result: Array[LimboState] = []
	var category: LimboState = get_node(category_path)
	
	var idx: int = category.get_index() + 1
	var _state := get_child(idx) as LimboState
	
	while _state is not CategoryComment:
		result.push_back(_state)
		idx += 1
		_state = get_child(idx) as LimboState
	
	return result


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


func revert() -> bool:
	return dispatch(EV_REVERT)

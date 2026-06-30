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


# Default States
@export_category("Default States")
@export var idle_state: LimboState
@export var block_state: LimboState
@export var move_state: LimboState
@export var jump_state: LimboState



# input_arr : ev_name
var input_map: Dictionary[PlayerState.Type, Dictionary] = {
	PlayerState.Type.IDLE : {
		
	},
	PlayerState.Type.JUMP : {
		
	},
}
var input_cache: PackedStringArray = PackedStringArray()

var _postpone: int = 0


func _ready() -> void:
	active_state_changed.connect(_on_active_state_changed)
	
	add_transition(ANYSTATE, get_state(^"Idle"), EV_REVERT)


func _input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo():
		if Input.is_action_just_pressed(&"left") or Input.is_action_just_pressed(&"right"):
			input_cache.push_back("front")
		elif Input.is_action_just_pressed(&"down"):
			input_cache.push_back("down")
		elif Input.is_action_just_pressed(&"up"):
			input_cache.push_back("up")
		
		if Input.is_action_just_pressed(&"attack"):
			input_cache.push_back("attack")
		if Input.is_action_just_pressed(&"kick"):
			input_cache.push_back("kick")
		
		_postpone = input_postpone


func _physics_process(_delta: float) -> void:
	var state: PlayerState.Type = get_player_state() # int
	
	if "attack" in input_cache or "kick" in input_cache:
		if input_map[state].has(input_cache):
			dispatch(input_map[state][input_cache])
			print("Dispatch => ", input_map[state][input_cache])
		input_cache.clear()
	
	if !input_cache.is_empty() and _postpone == 0:
		input_cache.clear()

	_postpone = maxi(_postpone - 1, 0)


func _exit_tree() -> void:
	_postpone = 0


func get_player_state() -> PlayerState.Type:
	return PlayerState.IDLE if get_player().is_on_floor() else PlayerState.JUMP


func _on_active_state_changed(current: LimboState, prev: LimboState) -> void:
	label.text = current.name


func get_action_input_map_list() -> PackedStringArray:
	return input_map.keys()


func get_player() -> Player:
	return get_parent() as Player


func get_state(state_name: NodePath) -> PlayerState:
	return get_node(state_name) as PlayerState


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

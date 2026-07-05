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
	PlayerState.Type.IDLE : {
		
	},
	PlayerState.Type.JUMP : {
		
	},
}
var input_cache: PackedStringArray = PackedStringArray()
var prev_input_dir: int = 0
var _postpone: int = 0


func _ready() -> void:
	var idle_state := get_state(^"Idle")
	add_transition(ANYSTATE, idle_state, EV_REVERT)

	active_state_changed.connect(
		func(current: LimboState, _prev: LimboState) -> void:
			label.text = current.name
	)

func _input(event: InputEvent) -> void:
	if event.is_pressed() and !event.is_echo():
		if Input.is_action_just_pressed(&"left") or Input.is_action_just_pressed(&"right"):
			var input_dir_x: int = int(Input.get_action_strength("right") - Input.get_action_strength("left"))
			if prev_input_dir == input_dir_x:
				input_cache.push_back("front")
				#print("push back front")
			else:
				prev_input_dir = input_dir_x
				input_cache.clear()
				input_cache.push_back("front")
				#print("cache clear and push back front")
			
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
	
	_postpone = maxi(_postpone - 1, 0)
	
	if ("attack" in input_cache) or ("kick" in input_cache):
		if input_map[state].has(input_cache):
			dispatch(input_map[state][input_cache])
			#print("Dispatch => ", input_map[state][input_cache])
		input_cache.clear()
		return

	if input_map[state].has(input_cache):
		dispatch(input_map[state][input_cache])
		input_cache.clear()
		return
	
	if !input_cache.is_empty() and _postpone == 0:
		input_cache.clear()



func _exit_tree() -> void:
	_postpone = 0


func get_player_state() -> PlayerState.Type:
	return PlayerState.IDLE if get_player().is_on_floor() else PlayerState.JUMP


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

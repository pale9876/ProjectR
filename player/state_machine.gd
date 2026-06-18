# state_machine.gd
extends LimboHSM


# Global States
const Idle: Script = preload("uid://c08p61o8pw6vo")
const Move: Script = preload("uid://c4q85mvv6k6wb")


@export var label: Label
@export var input_postpone: int = 8
@export var high_punch_state: LimboState


var cache: Dictionary[String, PackedStringArray] = {
	"direction" : PackedStringArray(),
	"action" : PackedStringArray(),
}

var _postpone: int = 0



func _enter_tree() -> void:
	_postpone = 0


func _ready() -> void:
	active_state_changed.connect(_on_active_state_changed)



func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"attack"):
		dispatch(&"high_punch")
		#cache["action"].push_back(&"attack")
		#_postpone = input_postpone
		#change_active_state(high_punch_state)
	
	if !get_move_list().is_empty():
		if !cache["action"].is_empty() or !cache["direction"].is_empty():
			pass

	_postpone = maxi(_postpone - 1, 0)
	
	if _postpone == 0:
		clear()


func _exit_tree() -> void:
	_postpone = 0


func get_move_list() -> Dictionary[PackedStringArray, LimboState]:
	return (blackboard.get_var(&"move_list") as Dictionary[PackedStringArray, LimboState])


func clear() -> void:
	cache = {
		"direction" : PackedStringArray(),
		"action" : PackedStringArray(),
	}


func _on_active_state_changed(current: LimboState, prev: LimboState) -> void:
	label.text = current.name

@tool
extends Resource
class_name CharacterDialogueLines


@export var dialogues: Dictionary[StringName, PackedStringArray] = {}
@export var motion_lines: Dictionary[StringName, MotionDialogueLine] = {}


func add_tag(tag_name: StringName, init_dialogue: String) -> void:
	if !has_tag(tag_name):
		dialogues[tag_name] = []
	
	dialogues[tag_name].push_back(init_dialogue)


func has_tag(tag_name: StringName) -> bool: return dialogues.has(tag_name)


func get_line(tag_name: StringName) -> String:
	if has_tag(tag_name):
		return Array(dialogues[tag_name]).pick_random()

	return ""

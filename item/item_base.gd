@tool
extends Resource
class_name ItemBase


enum Type
{
	HEAL,
	THROW,
}

@export var unique: bool = false
@export var name: String = ""
@export var condition: String
@export var anim: StringName = ""
@export var effect: Dictionary[Type, float] = {}

@export_multiline var description: String = ""

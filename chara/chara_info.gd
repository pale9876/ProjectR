@tool
extends Resource
class_name CharacterInformation

@export var name: String = ""

@export var base_speed: float = 200.

@export var base_atk: int = 1
@export var base_def: int = 0


@export_multiline var description: Array[String] = []


func _init() -> void:
	resource_local_to_scene = true

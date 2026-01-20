@tool
extends Resource
class_name UnitInformation


@export var name: String = ""
@export var speed: float = 200.
@export var jump_force: float = 350.
@export var acceleration: float = 3350.
@export var friction: float = 2250.


func _init() -> void:
	resource_local_to_scene = true


func store() -> Dictionary:
	var result: Dictionary = {}
	
	result["name"] = name
	result["speed"] = speed
	result["jump_force"] = jump_force
	
	return result

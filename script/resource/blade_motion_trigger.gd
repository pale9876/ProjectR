# blade_trigger.gd
@tool
extends Resource
class_name BladeMotionTrigger


@export var target_path: NodePath
@export var frame: int = 0
@export var target_method: StringName
@export var bind: Array


func execute(root: Node) -> void:
	root.get_node(target_path).callv(target_method, bind)


func get_dict() -> Dictionary:
	return {
		"method" : target_method,
		"args" : bind
	}


	

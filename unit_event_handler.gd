extends Node
class_name EventHandler


var _root: Node


func _enter_tree() -> void:
	_root = get_parent()

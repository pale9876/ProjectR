@tool
extends Node2D
class_name Stage


@export var entrance_point: Dictionary[String, Node2D] = {}


func _init() -> void:
	entrance_point.clear()

func _enter_tree() -> void:
	pass


func add_entrance_point(point: Node2D) -> void:
	entrance_point[point.name] = point

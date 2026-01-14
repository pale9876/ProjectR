@icon("res://aseprite/icon/entrance_point_icon.svg")
@tool
extends Node2D
class_name EntrancePoint2D


const ENTRANCE_POINT_ICON: Texture2D = preload("uid://ijfj1kiohbpt")

var _root: Node = null


func _enter_tree() -> void:
	_root = get_parent()
	if _root is Stage:
		_root



func _draw() -> void:
	draw_texture(
		ENTRANCE_POINT_ICON,
		Vector2.ZERO - (ENTRANCE_POINT_ICON.get_size() / 2.),
	)

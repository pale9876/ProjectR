@icon("res://aseprite/icon/spawn_point_icon.svg")
@tool
extends IconPoint2D
class_name SpawnPoint2D


const SPAWN_POINT_ICON = preload("res://aseprite/icon/spawn_point_icon.svg")


func _init() -> void:
	offset.y = -4.21
	icon = SPAWN_POINT_ICON

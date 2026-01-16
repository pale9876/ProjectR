@icon("res://aseprite/icon/entrance_point_icon.svg")
@tool
extends IconPoint2D
class_name EntrancePoint2D


const ENTRANCE_POINT_ICON: Texture2D = preload("uid://ijfj1kiohbpt")


func _init() -> void:
	offset.y = -7.18
	icon = ENTRANCE_POINT_ICON

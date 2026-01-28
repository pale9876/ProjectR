@icon("uid://dydcfuwtrplgr")
@tool
extends IconPoint2D
class_name SpawnPoint2D


const SPAWN_POINT_ICON: Texture2D = preload("uid://dydcfuwtrplgr")

func _init() -> void:
	offset.y = -4.21
	icon = SPAWN_POINT_ICON

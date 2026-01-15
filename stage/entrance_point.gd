@icon("res://aseprite/icon/entrance_point_icon.svg")
@tool
extends Node2D
class_name IconPoint2D


const ENTRANCE_POINT_ICON: Texture2D = preload("uid://ijfj1kiohbpt")


@export var texture: Texture2D = ENTRANCE_POINT_ICON:
	set(t):
		texture = t
		queue_redraw()


func _draw() -> void:
	draw_texture(
		ENTRANCE_POINT_ICON,
		Vector2.ZERO - (ENTRANCE_POINT_ICON.get_size() / 2.),
	)

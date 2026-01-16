@tool
extends Node2D
class_name IconPoint2D

@export var icon: Texture2D:
	set(t):
		icon = t
		queue_redraw()

@export var offset: Vector2 = Vector2.ZERO:
	set(value):
		offset = value
		queue_redraw()

func _draw() -> void:
	if icon:
		draw_texture(
			icon,
			Vector2.ZERO - (icon.get_size() / 2.) + offset,
		)

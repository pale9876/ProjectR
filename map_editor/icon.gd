# icon.gd
@tool
extends Sprite2D


# Import
const IconMap: Script = preload("uid://2l6nlafl6cnq")


@export var type: IconMap.Type = IconMap.NONE
@export var point_color: Color = Color.AQUA:
	set(color):
		point_color = color
		queue_redraw()
@export var radius: float = 2.:
	set(val):
		radius = val
		queue_redraw()


func _init() -> void:
	texture = IconMap.ICON_TEXTURE
	hframes = 16
	vframes = 16
	frame_coords = Vector2i(1, 0)
	offset = Vector2(0., - 10.)


func _draw() -> void:
	draw_circle(
		Vector2(), radius, point_color
	)

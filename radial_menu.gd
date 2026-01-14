@tool
extends Control
class_name RadialMenu


@export var background_color: Color = Color.DIM_GRAY
@export_range(0., 1., .01) var center: float = .2
@export var center_color: Color = Color.WHITE
@export var arc_step: int = 128
@export var radius: float = 10.
@export var margin: float = 1.


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, background_color)
	draw_arc(Vector2.ZERO, radius * center, 0., TAU, arc_step, center_color)

@tool
extends Node2D


@export var sprite_offset: Vector2 = Vector2(0., -64.)
@export var pos_x_grid_line_color: Color = Color(1.0, 0.0, 0.0, 1.0)
@export var neg_x_grid_line_color: Color = Color(1.0, 0.0, 1.0, 1.0)
@export var pos_y_grid_line_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var neg_y_grid_line_color: Color = Color(0.0, 1.0, 0.0, 1.0)



func _ready() -> void:
	get_sprite().position = sprite_offset


func _draw() -> void:
	draw_line(Vector2(), Vector2(512., 0.), pos_x_grid_line_color)
	draw_line(Vector2(), Vector2(-512., 0.), neg_x_grid_line_color)
	draw_line(Vector2(), Vector2(0., 512.), pos_y_grid_line_color)
	draw_line(Vector2(), Vector2(0., -512.), neg_y_grid_line_color)


func get_sprite() -> Node2D:
	return get_node(^"Sprite") as Node2D


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox") as Hurtbox

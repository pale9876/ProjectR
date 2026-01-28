@tool
extends InnerUI
class_name MarkerUI

@export var show_mark: bool = false:
	set(toggle):
		show_mark = toggle
		queue_redraw()

@export var mark_line: float = 10.:
	set(value):
		mark_line = value
		queue_redraw()

@export_range(-1., 3., 0.001) var bold: float = 2.:
	set(value):
		bold = value
		queue_redraw()


func _init() -> void:
	size = Vector2.ZERO


func _draw() -> void:
	if !show_mark: return
	
	draw_line(
		Vector2(- mark_line / 2., 0.),
		Vector2(mark_line / 2., 0.),
		Color.ALICE_BLUE,
		bold
	) # 가로선
	
	draw_line(
		Vector2(0., - mark_line / 2.),
		Vector2(0., mark_line / 2.),
		Color.ALICE_BLUE,
		bold
	) # 세로선

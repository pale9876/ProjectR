@tool
extends Control




func _draw() -> void:
	if !Engine.is_editor_hint(): return
	
	# draw center x
	var center_x: float = size.x / 2.
	var grid_y: float = size.y * .75
	draw_line(
		Vector2(center_x, 0.),
		Vector2(center_x, grid_y),
		Color.WHITE,
	)

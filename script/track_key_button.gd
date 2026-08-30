# track_key_button.gd
@tool
extends Control


var data: Dictionary


func _init() -> void:
	size = Vector2(8., 8.)
	
	mouse_entered.connect(
		func() -> void:
			pass
	)

	mouse_exited.connect(
		func() -> void:
			pass
	)


func _draw() -> void:
	draw_circle(
		Vector2(4., 4.), 4., Color.WHITE, true
	)

	

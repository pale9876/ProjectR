# filter_screen.gd
@tool
extends ColorRect
class_name FilterScreen


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

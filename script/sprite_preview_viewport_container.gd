# sprite_preview_viewport_container.gd
extends SubViewportContainer


@onready var target_grid: Node2D = %TargetGrid
@onready var preview_camera: Camera2D = %PreviewCamera


var _dragging: bool = false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_echo():
			_dragging = is_dragging(event)
			preview_camera.zoom = (preview_camera.zoom + zoom_in_out(event)).clampf(.5, 3.)
	
	if event is InputEventMouseMotion:
		if _dragging:
			preview_camera.global_position -= event.screen_relative


func target_grid_set_preview(node: Node2D) -> void:
	if target_grid.get_child_count() > 0:
		target_clear_preview()
	target_grid.add_child(node)


func target_clear_preview() -> void:
	for node: Node in get_children():
		node.queue_free.call_deferred()


func is_dragging(ev: InputEventMouseButton) -> bool:
	return ev.pressed and ev.button_index == MouseButton.MOUSE_BUTTON_RIGHT


func zoom_in_out(event: InputEventMouseButton) -> Vector2:
	return Vector2(.05, .05) if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP\
		else - Vector2(.05, .05) if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN\
		else Vector2()


	

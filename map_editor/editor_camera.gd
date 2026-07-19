# grid_camera.gd
extends Camera2D


# Import
const MapGrid: Script = preload("uid://b2wn5idfki8e3")


@export var amount: float = 500.
@export var margin: int = 5






func _enter_tree() -> void:
	make_current()


func _process(_delta: float) -> void:
	if !is_current() or !get_grid().is_cursor_inside_window(): return
	
	var input_dir: Vector2 = Input.get_vector(
		"left", "right", "up", "down"
	)
	if input_dir != Vector2():
		global_position += input_dir * amount * _delta
	
	var _relation := relation()
	if _relation != Vector2():
		global_position += _relation * amount * _delta
	
	if Input.is_action_just_pressed("jump"):
		reset()


func _unhandled_input(_event: InputEvent) -> void:
	if !get_grid().is_cursor_inside_window():
		return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		zoom = (zoom + Vector2(.1, .1)).clampf(.1, 5.)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		zoom = (zoom - Vector2(.1, .1)).clampf(.1, 5.)


func relation() -> Vector2:
	var result: Vector2 = Vector2()
	var vp_pos: Vector2i = Vector2i(get_viewport_rect().size / 2.)
	var mouse_pos: Vector2i = Vector2i(get_local_mouse_position())
	
	if mouse_pos.x < - vp_pos.x + 2:
		result.x = - 1.
	elif mouse_pos.x > vp_pos.x - 2:
		result.x = 1.
	
	if mouse_pos.y > vp_pos.y - 2:
		result.y = 1.
	elif mouse_pos.y < - vp_pos.y + 2:
		result.y = - 1.
	
	return result


func reset() -> void:
	var center: Vector2 = get_grid().get_cursor().get_center()
	global_position = center


func get_grid() -> MapGrid:
	return get_parent() as MapGrid




	

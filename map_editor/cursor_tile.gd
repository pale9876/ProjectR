# cursor_tile.gd
extends TileMapLayer


# Import
const MapGrid: Script = preload("uid://b2wn5idfki8e3")

#const TRANSPARENT: Vector2i = Vector2i(0, 1)
const CURSOR: Vector2i = Vector2i()


signal cursor_changed(prev_cell: Vector2i, current: Vector2i)
signal cursor_pressed(point: Vector2i)
signal icon_changed(point: Vector2i)
signal cursor_dragged(rect: Rect2i)


var map_size: Vector2i = Vector2i(16, 16)


var cursor: Vector2i:
	set(val):
		if cursor != val:
			var _value := val.clamp(
				Vector2i(), (map_size - Vector2i.ONE)
			)
			cursor_changed.emit(cursor, _value)
			cursor = _value
var offset: Vector2i = Vector2i(8, 8)


var _drag: bool = false
var _drag_started: Vector2i
var _drag_ended: Vector2i:
	set(value):
		_drag_ended = value
		var rect: Rect2i = Rect2i(
			_drag_started,
			_drag_ended - _drag_started
		)
		if absi(rect.get_area()) > 1:
			cursor_dragged.emit(rect)


func _enter_tree() -> void:
	cursor_changed.connect(
		func(prev: Vector2i, curr: Vector2i) -> void:
			#var tile := get_tile()
			var prev_coord: Vector2 = Vector2(prev)
			var curr_coord: Vector2 = Vector2(curr)
			erase_cell(prev_coord)
			set_cursor(curr_coord)
	)
	
	cursor_dragged.connect(
		func(region: Rect2i) -> void:
			pass
			#print(region)
	)


func get_cursor_position() -> Vector2i:
	return Vector2i(
		(get_global_mouse_position() - Vector2(offset)).snappedf(float(get_tile_size())) / 16.
	)


func _process(_delta: float) -> void:
	if get_grid() == null: return
	
	cursor = get_cursor_position()
	
	if Input.is_action_just_pressed(&"mouse_left"):
		if contain_cursor():
			cursor_pressed.emit(cursor)
	elif Input.is_action_just_pressed(&"devote"):
		if contain_cursor():
			icon_changed.emit(
				Vector2i(get_global_mouse_position().round())
			)


	if !_drag and Input.is_action_pressed(&"mouse_left"):
		_drag_started = cursor
		_drag = true
	elif _drag and Input.is_action_just_released(&"mouse_left"):
		_drag_ended = cursor
		_drag = false


func contain_cursor() -> bool:
	var cursor_rect: Rect2 = get_cursor_rect()
	var mouse_pos: Vector2 = get_local_mouse_position()
	return cursor_rect.has_point(mouse_pos)


func _draw() -> void:
	draw_rect(
		get_cursor_rect(), Color(0.631, 0.753, 1.0, 0.247)
	)


func get_cursor_rect() -> Rect2:
	return Rect2(Vector2(), get_tile_size() * map_size)


func get_tile_size() -> int:
	return (get_parent() as MapGrid).tile_size


func get_grid() -> MapGrid:
	return get_parent() as MapGrid


func is_editing() -> bool:
	return get_grid().get_edit() == self


func get_center() -> Vector2:
	return Vector2(get_tile_size() * map_size) / 2.


func erase(coord: Vector2i) -> void:
	erase_cell(coord)


func set_cursor(coord: Vector2i) -> void:
	set_cell(coord, 0, CURSOR)

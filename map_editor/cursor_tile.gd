# cursor_tile.gd
extends TileMapLayer


# Import
const MapGrid: Script = preload("uid://b2wn5idfki8e3")

#const TRANSPARENT: Vector2i = Vector2i(0, 1)
const CURSOR: Vector2i = Vector2i()


signal cursor_changed(prev_cell: Vector2i, current: Vector2i)
signal cursor_pressed(point: Vector2i)
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
var _drag: Rect2i = Rect2i()


func _enter_tree() -> void:
	cursor_changed.connect(
		func(prev: Vector2i, curr: Vector2i) -> void:
			#var tile := get_tile()
			var prev_coord: Vector2 = Vector2(prev)
			var curr_coord: Vector2 = Vector2(curr)
			erase_cell(prev_coord)
			set_cursor(curr_coord)
	)


func _process(_delta: float) -> void:
	cursor = Vector2i(
		(get_global_mouse_position() - Vector2(offset)).snappedf(float(get_tile_size())) / 16.
	)
	
	if Input.is_action_just_pressed(&"mouse_left"):
		var cursor_rect: Rect2 = get_cursor_rect()
		if cursor_rect.has_point(get_local_mouse_position()):
			cursor_pressed.emit(cursor)


func _draw() -> void:
	draw_rect(
		get_cursor_rect(), Color(0.631, 0.753, 1.0, 0.247)
	)

func get_cursor_rect() -> Rect2:
	return Rect2(Vector2(), get_tile_size() * map_size)


func get_tile_size() -> int:
	return (get_parent() as MapGrid).tile_size



func get_center() -> Vector2:
	return Vector2(get_tile_size() * map_size) / 2.


func erase(coord: Vector2i) -> void:
	erase_cell(coord)


func set_cursor(coord: Vector2i) -> void:
	set_cell(coord, 0, CURSOR)

# map_grid.gd
extends Node2D


# Import
const CursorTile: Script = preload("uid://c347castjr8h1")
const EditorCamera: Script = preload("uid://c17vpmahfebd0")


# Const
const DEFAULT_TILE_SIZE: int = 16
var tile_size: int = DEFAULT_TILE_SIZE


func awake() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _ready() -> void:
	get_editor_camera().reset()
	get_cursor().cursor_pressed.connect(
		func(point: Vector2i) -> void:
			print(point)
	)


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func get_tile() -> TileMapLayer:
	return get_node(^"MapTile") as TileMapLayer


func get_cursor() -> CursorTile:
	return get_node(^"CursorTile") as CursorTile


func get_editor_camera() -> EditorCamera:
	return get_node(^"EditorCamera") as EditorCamera

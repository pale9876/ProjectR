# map_grid.gd
extends Node2D


# Import
const CursorTile: Script = preload("uid://c347castjr8h1")
const EditorCamera: Script = preload("uid://c17vpmahfebd0")


# Const
const DEFAULT_TILE_SIZE: int = 16

var tile_size: int = DEFAULT_TILE_SIZE

var _edit: Node2D = null
var theme: StringName = &""

var _wm_entered: bool = false


func awake() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func get_edit() -> Node2D:
	return _edit


func change_edit() -> void:
	pass


func next() -> void:
	pass


func prev() -> void:
	pass


func create_map_guidance() -> MapGuidance:
	var guide: MapGuidance = MapGuidance.new()
	# Do Something
	guide.location
	guide.size
	return guide


func _enter_tree() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func _ready() -> void:
	get_editor_camera().reset()
	get_cursor().cursor_pressed.connect(
		func(_point: Vector2i) -> void:
			pass
			#print(point)
	)
	#awake()


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_ENTER:
			_wm_entered = true
		NOTIFICATION_WM_MOUSE_EXIT:
			_wm_entered = false


func get_tile() -> TileMapLayer:
	return get_node(^"MapTile") as TileMapLayer


func get_cursor() -> CursorTile:
	return get_node(^"CursorTile") as CursorTile


func get_editor_camera() -> EditorCamera:
	return get_node(^"EditorCamera") as EditorCamera


func is_cursor_inside_window() -> bool:
	return _wm_entered

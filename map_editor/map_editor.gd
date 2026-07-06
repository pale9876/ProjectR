# map_editor.gd
extends CanvasLayer


# Path
const DEFAULT_PATH: String = "user://"
const EXT: String = ".mapsettings"


# Nodes
@onready var map_title: LineEdit = %MapTitle
@onready var submit: Button = %Submit
@onready var init_settings: PanelContainer = $InitSettings
@onready var grid: GridContainer = $ScrollContainer/Grid


# File Dialogs
@onready var settings_file_dialog: FileDialog = $SettingsFileDialog
@onready var scene_file_dialog: FileDialog = $SceneFileDialog


var _data: MapData = null


func _init() -> void:
	pass


func _enter_tree() -> void:
	var file_exists: bool = ResourceLoader.exists(DEFAULT_PATH, "Resource")
	
	if file_exists:
		var data: Resource = ResourceLoader.load(DEFAULT_PATH, "Resource")
	
		if data != null:
			_data = data
			init_settings.hide()
			load_from_data(_data)


func _ready() -> void:
	submit.button_up.connect(
		func() -> void:
			create_data()
			init_settings.hide()
	)


func create_data() -> void:
	var data := MapData.new()
	
	data.title = get_title()
	data.map_size = get_map_size()
	data.tile_size = get_tile_size()
	
	var err: Error = ResourceSaver.save(data, DEFAULT_PATH + String(get_title()))
	if err != OK:
		printerr("Save Error => ", err)
		return

	_data = data


func load_from_data(d: MapData) -> void:
	print("map_size => ", d.map_size, "| tile_size => ", d.tile_size)


func save_data() -> void:
	var err: Error = ResourceSaver.save(_data, DEFAULT_PATH + String(get_title()))
	if err != OK:
		printerr("Save Error => ", err)


func get_title() -> StringName:
	return StringName((get_node(^"%MapTitle") as LineEdit).text)


func get_map_size() -> Vector2i:
	return Vector2i(
		get_int_value_from_edit(^"%MapSizeX"),
		get_int_value_from_edit(^"%MapSizeY")
	)


func get_tile_size() -> Vector2i:
	return Vector2i(
		get_int_value_from_edit(^"%TileSizeX"),
		get_int_value_from_edit(^"%TileSizeY")
	)


func get_int_value_from_edit(node_path: NodePath) -> int:
	var line_edit := get_node(node_path) as LineEdit
	var txt: String = line_edit.placeholder_text if line_edit.text.is_empty() else line_edit.text
	return txt.to_int()


func clear() -> void:
	for node: Node in grid.get_children():
		node.queue_free()


class MapData extends Resource:
	var title: StringName = &""
	var map_size: Vector2i
	var tile_size: Vector2i
	var tiles: Dictionary[Vector2i, Dictionary] = {
		# Vector2i : {
		# "type" : type,
		# ""
		#}
	}


class MapEditorSettings extends Resource:
	var default_path: String

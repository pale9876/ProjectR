# map_editor.gd
extends CanvasLayer


# Import
const MapGrid: Script = preload("uid://b2wn5idfki8e3")
const Entry: Script = preload("uid://xhpxarx6fs8a")


# Path
const DEFAULT_PATH: String = "user://"
const DEFAULT_SETTINGS_PATH: String = "user://mapeditor.settings"
const EXT: String = ".settings"


# Nodes
@onready var grid: MapGrid = $ScrollContainer/Grid
@onready var init_settings: PanelContainer = $InitSettings


# File Dialogs
@onready var settings_file_dialog: FileDialog = $SettingsFileDialog
@onready var scene_file_dialog: FileDialog = $SceneFileDialog


var settings: MapEditorDefaultSettings
var _data: MapData = null


func get_grid() -> MapGrid:
	return get_node(^"%Grid") as MapGrid


func get_entry() -> Entry:
	return get_node(^"EditorEntry") as Entry


func _init() -> void:
	if !ResourceLoader.exists(DEFAULT_SETTINGS_PATH, "Resource"):
		var _res := MapEditorDefaultSettings.new()
		var err := ResourceSaver.save(_res, DEFAULT_SETTINGS_PATH)
		if err != OK:
			print("Err => ", err)
		settings = _res
		return

	var _settings: Resource = ResourceLoader.load(DEFAULT_SETTINGS_PATH)
	settings = _settings


func _enter_tree() -> void:
	var file_exists: bool = ResourceLoader.exists(DEFAULT_PATH, "Resource")
	
	if file_exists:
		var data: Resource = ResourceLoader.load(DEFAULT_PATH, "Resource")
	
		if data != null:
			_data = data
			init_settings.hide()
			load_from_data(_data)


#func _ready() -> void:
	#submit.button_up.connect(
		#func() -> void:
			#create_data()
			#init_settings.hide()
	#)


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
	grid.clear()


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


class MapEditorDefaultSettings extends Resource:
	var default_path: String

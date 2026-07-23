# map_editor.gd
extends CanvasLayer


# Import (Resource Format)
const MepSaver: Script = preload("uid://6v3eoduxeh4r")
const MepLoader: Script = preload("uid://drswusyla761m")


# Import
const MapGrid: Script = preload("uid://b2wn5idfki8e3")
const EditorEntry: Script = preload("uid://xhpxarx6fs8a")
const InitSettings: Script = preload("uid://cwphc46lnkhgf")
const LoadMapFD: Script = preload("uid://dbci2v2xkthhv")
const MapEditorProject: Script = preload("uid://baf8mmb2udiga")


@export_dir var target_directory: String


func _init() -> void:
	var mep_saver: MepSaver = MepSaver.new()
	ResourceSaver.add_resource_format_saver(mep_saver)


func _ready() -> void:
	var editor_entry := get_entry()
	var submit := get_init_settings().get_submit()
	
	editor_entry.visible = true
	editor_entry.request_load.connect(
		func(map: MapEditorProject) -> void:
			print(map.title)
			print(map.map_size)
	)
	
	submit.button_up.connect(
		func() -> void:
			pass
	)


func get_init_settings() -> InitSettings:
	return get_node(^"InitSettings") as InitSettings


func get_entry() -> EditorEntry:
	return get_node(^"EditorEntry") as EditorEntry


func get_grid() -> MapGrid:
	return get_node(^"MapGrid") as MapGrid


func get_load_map_fd() -> LoadMapFD:
	return get_node(^"LoadMapFD") as LoadMapFD

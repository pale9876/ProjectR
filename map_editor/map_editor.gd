# map_editor.gd
extends CanvasLayer


# Import
const MapGrid: Script = preload("uid://b2wn5idfki8e3")
const EditorEntry: Script = preload("uid://xhpxarx6fs8a")
const InitSettings: Script = preload("uid://cwphc46lnkhgf")
const LoadMapFD: Script = preload("uid://dbci2v2xkthhv")


func _ready() -> void:
	get_entry().visible = true
	get_init_settings().get_submit().button_up.connect(
		func() -> void:
			pass
	)
	#get_load_map_fd().popup_file_dialog()


func get_init_settings() -> InitSettings:
	return get_node(^"InitSettings") as InitSettings


func get_entry() -> EditorEntry:
	return get_node(^"EditorEntry") as EditorEntry


func get_grid() -> MapGrid:
	return get_node(^"MapGrid") as MapGrid


func get_load_map_fd() -> LoadMapFD:
	return get_node(^"LoadMapFD") as LoadMapFD

# editor_entry.gd
extends PanelContainer


# Import
const MepLoader: Script = preload("uid://drswusyla761m")
const MapEditorProject: Script = preload("uid://baf8mmb2udiga")


const DEFAULT_FOLDER: String = "user://"
const DEFAULT_SAVE_DIR: String = "res://map_editor/"
const EXT: String = ".mep"

@export_dir var target_directory: String = "res://map_editor"


func _init() -> void:
	visible = true


func _enter_tree() -> void:
	var res := ResourceLoader.load("res://map_editor/example.mep") as MapEditorProject
	print(res.title)
	print(res.map_size)
	get_files()


func get_files() -> void:
	var list: PackedStringArray = ResourceLoader.list_directory("user://")
	print(list)

func refresh() -> void:
	pass

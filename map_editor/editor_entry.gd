# editor_entry.gd
extends PanelContainer


# Import
const MepLoader: Script = preload("uid://drswusyla761m")
const MapEditorProject: Script = preload("uid://baf8mmb2udiga")
const MapEditor: Script = preload("uid://dh7o2hk7gte68")


# Const
const DEFAULT_SAVE_DIR: String = "res://map_editor/"
const EXT: String = ".mep"


signal request_load(map: MapEditorProject)


func _init() -> void:
	var mep_loader: MepLoader = MepLoader.new()
	ResourceLoader.add_resource_format_loader(mep_loader)
	
	visible = true


func _ready() -> void:
	var project_list := get_project_list()
	
	refresh()
	
	project_list.item_selected.connect(
		func(idx: int) -> void:
			var project_name: String = project_list.get_item_text(idx)
			var project_path: String = get_target_dir() + project_name + EXT
			var map := ResourceLoader.load(project_path) as MapEditorProject
			request_load.emit(map)
	)


func refresh() -> void:
	var project_list := get_project_list()
	var list: PackedStringArray = ResourceLoader.list_directory(get_target_dir())
	
	project_list.clear()
	
	for file_name in list:
		if file_name.get_extension() == "mep":
			project_list.add_item(file_name.get_basename())


func get_project_list() -> ItemList:
	return get_node(^"%ProjectList") as ItemList


func get_target_dir() -> String:
	var dir: String = get_editor().target_directory
	return dir if !dir.is_empty() and dir.is_relative_path() else DEFAULT_SAVE_DIR


func get_editor() -> MapEditor:
	return get_parent() as MapEditor

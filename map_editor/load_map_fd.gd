# load_map_fd.gd
extends FileDialog


# Import
const MapEditorProject: Script = preload("uid://baf8mmb2udiga")


func _init() -> void:
	filters = PackedStringArray([
		"*.mep"
	])
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	display_mode = FileDialog.DISPLAY_LIST
	access = FileDialog.ACCESS_USERDATA

	file_selected.connect(_file_selected)


func _file_selected(path: String) -> void:
	pass

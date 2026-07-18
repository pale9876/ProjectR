# load_map_fd.gd
extends FileDialog


func _init() -> void:
	filters = PackedStringArray([
		"*.res"
	])
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	display_mode = FileDialog.DISPLAY_LIST
	access = FileDialog.ACCESS_USERDATA
	

	file_selected.connect(_file_selected)


func _file_selected(path: String) -> void:
	pass

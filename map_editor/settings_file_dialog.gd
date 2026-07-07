extends FileDialog


# Import
const Editor: Script = preload("uid://dh7o2hk7gte68")


func _init() -> void:
	file_selected.connect(_file_selected)


func _file_selected(path: String) -> void:
	var res: Resource = ResourceLoader.load(path)
	if res is Editor.MapData:
		pass

func get_editor() -> Editor:
	return get_parent() as Editor

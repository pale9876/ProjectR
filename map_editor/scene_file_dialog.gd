extends FileDialog


func _init() -> void:
	file_selected.connect(_file_selected)


func _file_selected(path: String) -> void:
	var res: Resource = ResourceLoader.load(path)
	if res is MapInfo:
		pass

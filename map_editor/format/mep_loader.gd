extends ResourceFormatLoader


const MapEditorProject = preload("uid://baf8mmb2udiga")


func _handles_type(type: StringName) -> bool:
	return type == &"MapEditorProject"


func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["mep"])

func _load(
	path: String,
	original_path: String,
	use_sub_threads: bool,
	cache_mode: int
) -> Variant:
	
	var cm: ResourceLoader.CacheMode = cache_mode as ResourceLoader.CacheMode
	var exists: bool = FileAccess.file_exists(path)
	if !exists:
		return null
	
	var file := FileAccess.open(path, FileAccess.READ)
	var open_err: Error = file.get_error()
	if open_err != OK:
		printerr("Error Opening Map Editor Project :: " + path)
		return null
	
	var mep: MapEditorProject = MapEditorProject.new()
	
	mep.title = StringName(file.get_pascal_string())
	mep.size = file.get_var() as Vector2i
	
	
	return mep

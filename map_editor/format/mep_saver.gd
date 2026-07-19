extends ResourceFormatSaver


const MapEditorProject: Script = preload("uid://baf8mmb2udiga")


func _recognize(resource: Resource) -> bool:
	return (resource != null) and resource is MapEditorProject


func _get_recognized_extensions(_resource: Resource) -> PackedStringArray:
	return PackedStringArray(["mep"])


func _recognize_path(res: Resource, path: String) -> bool:
	var ext: String = path.get_extension()
	var valid_exts: PackedStringArray = _get_recognized_extensions(res)
	if ext in valid_exts:
		return true
	
	return false


func _save(res: Resource, path: String, flags: int) -> Error:
	if !_recognize(res):
		return Error.FAILED
	
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE_READ)
	var err: Error = file.get_error()
	if err != OK:
		return err
		
	var map_info: MapEditorProject = res as MapEditorProject
	file.store_pascal_string(map_info.title)
	file.store_32(map_info.map_size.x)
	file.store_32(map_info.map_size.y)
	
	return Error.OK

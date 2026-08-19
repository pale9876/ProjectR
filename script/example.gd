extends Control


@export var path: String:
	get:
		return path if !path.is_empty() else "res://"


func _ready() -> void:
	var globalized: String = ProjectSettings.globalize_path(path)
	
	($PDFormBase as PDFormBase).build_export(
		globalized, true
	)


func get_desktop_path() -> String:
	var ret = ""
	var slashes = 0
	for i in OS.get_user_data_dir():
		if i == "/":
			slashes += 1
		if slashes == 3:
			return ret + "/Desktop"
		else:
			ret += i
	
	return ret

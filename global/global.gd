extends Node

enum {
	INIT,
	READY,
	INGAME,
}


var state: int = INIT
var os: String = ""


func _enter_tree() -> void:
	os = OS.get_name()
	if os == "Windows":
		pass
	elif os == "Android":
		pass
	elif os == "Web":
		pass


class SaveData extends Resource:
	pass

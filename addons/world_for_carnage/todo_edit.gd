@tool
extends TextEdit
class_name TodoEdit


const SAVE_PATH: String = "res://addons/world_for_carnage/cache/"


func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_PRE_SAVE:
		pass
		#ResourceSaver.save()
		

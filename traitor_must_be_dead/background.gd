@tool
extends Endeka

func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		Global.background = self

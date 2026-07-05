@tool
extends LimboState
class_name CategoryComment



func _init() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


#func _enter_tree() -> void:
	#if !Engine.is_editor_hint():
		#queue_free()

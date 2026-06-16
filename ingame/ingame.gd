# ingame.gd
extends CanvasLayer


# Import


func _init() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	follow_viewport_enabled = true

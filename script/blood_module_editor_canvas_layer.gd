# blood_module_editor_canvas_layer.gd
extends CanvasLayer


func _enter_tree() -> void:
	get_viewport().size = Vector2i(1280, 720)
	get_window().content_scale_size = Vector2i(1280, 720)
	
	ProjectSettings.set("global/EDITOR_MODE", true)


func _exit_tree() -> void:
	get_viewport().size = Vector2i(640, 360)
	get_window().content_scale_size = Vector2i(640, 360)
	ProjectSettings.set("global/EDITOR_MODE", false)

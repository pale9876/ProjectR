@tool
extends EditorInspectorPlugin


const APInspectorDock = preload("./sprite_inspector_dock.tscn")


func _can_handle(object: Object):
	return object_is_basic(object)


func object_is_basic(object: Object) -> bool:
	return object is Sprite2D || object is Sprite3D || object is TextureRect


func object_is_custom(object: Object) -> bool:
	return false


func _parse_end(object):
	var dock = APInspectorDock.instantiate()
	dock.target_node = object
	add_custom_control(dock)

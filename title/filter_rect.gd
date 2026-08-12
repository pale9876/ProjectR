@tool
extends ColorRect
class_name FilterRect


@export var shader: ShaderMaterial:
	set(val):
		shader = val
		if val:
			material = shader
	get:
		return material as ShaderMaterial


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

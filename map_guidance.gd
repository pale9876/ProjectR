extends Resource
class_name MapGuidance


@export var scene: PackedScene
@export var location: Vector2i = Vector2i()
@export var size: Vector2i = Vector2i.ONE


func get_region() -> Rect2i:
	return Rect2i(location, size)

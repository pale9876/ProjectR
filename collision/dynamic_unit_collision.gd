@tool
extends CollisionShape2D
class_name DynamicUnitCollision


@export var width: int = 48.:
	set(value):
		width = maxi(0, snappedi(value, 2))
		changed()
@export var height: int = 64.:
	set(value):
		height = maxi(0, value)
		changed()


func _init() -> void:
	shape = ConvexPolygonShape2D.new()
	changed()


func changed() -> void:
	var _width := get_width_height().x
	var _height := get_width_height().y
	
	var top_left: Vector2 = Vector2(- _width / 2., - _height)
	var top_right: Vector2 = Vector2(_width / 2., - _height)
	var bottom_left: Vector2 = Vector2(- _width / 2., 0.)
	var bottom_right: Vector2 = Vector2(_width / 2., 0.)

	(shape as ConvexPolygonShape2D).points = PackedVector2Array([
		top_left, top_right, bottom_right, bottom_left
	])


func get_width_height() -> Vector2:
	return Vector2(float(width), float(height))

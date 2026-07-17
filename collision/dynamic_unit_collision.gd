@tool
extends CollisionShape2D
class_name DynamicUnitCollision


@export var width: int = 38:
	set(value):
		width = maxi(0, snappedi(value, 2))
		changed()
@export var height: int = 92:
	set(value):
		height = maxi(0, value)
		changed()
@export var offset_y: int = 0:
	set(val):
		offset_y = val
		changed()



func _init() -> void:
	#var convex := ConvexPolygonShape2D
	shape = RectangleShape2D.new()
	changed()


func changed() -> void:
	(shape as RectangleShape2D).size = get_width_height()
	position.y = - get_width_height().y / 2. - offset_y


func get_width_height() -> Vector2:
	return Vector2(float(width), float(height))

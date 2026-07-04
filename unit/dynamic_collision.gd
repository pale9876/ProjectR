@tool
extends CollisionPolygon2D
class_name DynamicCollision


@export var offset: Vector2 = Vector2(-10., 128.):
	set(value):
		offset = value
		if is_inside_tree():
			set_dynamic(offset, height, dist, range_ratio)
@export var height: float = 200.:
	set(value):
		height = maxf(0., value)
		if is_inside_tree():
			set_dynamic(offset, height, dist, range_ratio)
@export var dist: float = 300.:
	set(value):
		dist = maxf(value, 0.)
		if is_inside_tree():
			set_dynamic(offset, height, dist, range_ratio)
@export_range(0., 1., .01) var range_ratio: float = 1.:
	set(value):
		range_ratio = clampf(value, 0., 1.)
		if is_inside_tree():
			set_dynamic(offset, height, dist, range_ratio)



func set_dynamic(offset: Vector2, height: float, dist: float, ratio: float) -> void:
	var result: PackedVector2Array = PackedVector2Array()
	
	var top_left: Vector2 = offset - Vector2(0., height / 2.)
	var bottom_left: Vector2 = offset + Vector2(0., height / 2.)
	
	var top_right: Vector2 = Vector2(top_left.x + dist * ratio, top_left.y)
	var bottom_right: Vector2 = Vector2(bottom_left.x + dist * ratio, bottom_left.y)
	
	result.push_back(top_left)
	result.push_back(bottom_left)
	result.push_back(bottom_right)
	result.push_back(top_right)
	
	set_polygon(result)

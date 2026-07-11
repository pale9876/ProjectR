@tool
extends HitboxShape
class_name HitPolygon


@export var offset: Vector2 = Vector2():
	set(value):
		offset = value
		set_collision()
@export var height: float = 62.:
	set(value):
		height = maxf(value, 0.)
		set_collision()
@export var hit_range: float = 300.:
	set(value):
		hit_range = maxf(value, 0.)
		set_collision()
@export_range(0., 1., .001) var ratio: float = 1.:
	set(value):
		ratio = clampf(value, 0., 1.)
		set_collision()


func _init() -> void:
	shape = ConvexPolygonShape2D.new()
	visible = false
	disabled = true


func _enter_tree() -> void:
	set_collision()


func set_collision() -> void:
	var cent_height: Vector2 = Vector2(offset.x, offset.y)
	
	var top_left: Vector2 = Vector2(cent_height.x + offset.x, cent_height.y - height / 2.)
	var bottom_left: Vector2 = Vector2(cent_height.x + offset.x, cent_height.y + height / 2.)
	
	var bottom_right: Vector2 = Vector2(bottom_left.x + hit_range, bottom_left.y)
	var top_right: Vector2 = Vector2(top_left.x + hit_range, top_left.y)
	
	(shape as ConvexPolygonShape2D).points = [
		top_left, bottom_left, bottom_right, top_right
	]

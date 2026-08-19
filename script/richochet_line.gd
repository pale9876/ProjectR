@tool
extends Line2D


@export var start_offset: float = 25.:
	set(value):
		start_offset = maxf(0., value)
@export var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value.normalized() if !value.is_normalized() else value
@export_flags_2d_physics var mask: int = 3
@export var bound: int = 2:
	set(value):
		bound = maxi(value, 0)


var bound_points: PackedVector2Array = PackedVector2Array()
var _progress: float = 0.:
	set(value):
		_progress = clampi(value, 0., 1.)


func _init() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED


func shot() -> void:
	add_point(start_offset * direction)


func start_point() -> Vector2:
	return start_offset * direction



func create_ray() -> void:
	pass


func create_hitpoint() -> void:
	pass


func create_bound_point() -> void:
	pass


	

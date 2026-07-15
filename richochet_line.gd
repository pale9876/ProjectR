extends Line2D


@export var start_offset: Vector2 = Vector2()
@export var direction: Vector2 = Vector2.RIGHT
@export_flags_2d_physics var mask: int = 3


var bound_points: PackedVector2Array = PackedVector2Array()


func _init() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED


func _enter_tree() -> void:
	pass


func start_point() -> void:
	pass


func create_ray() -> void:
	pass


func create_hitpoint() -> void:
	pass


func create_bound_point() -> void:
	pass


	

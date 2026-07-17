@tool
extends Sprite2D
class_name BlobShadow


@export var colors: PackedColorArray = PackedColorArray([Color.BLACK, Color.TRANSPARENT]):
	set(value):
		colors = value
		if _gradient:
			_gradient.colors = colors
@export var width: int = 64:
	set(value):
		width = maxi(0, value)
		if texture:
			(texture as GradientTexture2D).width = width
@export var height: int = 10:
	set(value):
		height = maxi(0, value)
		if texture:
			(texture as GradientTexture2D).height = height
@export_range(.5, 1., .001) var radius: float = .789:
	set(value):
		radius = clampf(value, .5, 1.)
		if texture:
			(texture as GradientTexture2D).fill_to = fill_to()
@export_flags_2d_physics var mask: int = 1


var _gradient: Gradient


func _init() -> void:
	_gradient = create_blob_shadow()
	
	var gradient_texture_2d := GradientTexture2D.new()
	gradient_texture_2d.width = width
	gradient_texture_2d.height = height
	gradient_texture_2d.fill = GradientTexture2D.FILL_RADIAL
	gradient_texture_2d.fill_from = Vector2(.5, .5)
	gradient_texture_2d.fill_to = fill_to()
	
	gradient_texture_2d.gradient = _gradient
	texture = gradient_texture_2d


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return

	# Shadow
	var unit := get_unit()
	var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		unit.global_position,
		unit.global_position + Vector2(0., 3000.),
		mask
	)
	
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	
	if !result.is_empty():
		var intersect_point := result["position"] as Vector2
		var scale_progress: float = unit.global_position.distance_to(intersect_point) / 3000.
		scale = Vector2((1. - scale_progress), (1. - scale_progress))
		global_position = intersect_point


func fill_to() -> Vector2:
	return Vector2(radius, radius)


func create_blob_shadow() -> Gradient:
	var gradient := Gradient.new()
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	gradient.colors = colors
	
	return gradient


func get_unit() -> CharacterBody2D:
	return get_parent() as CharacterBody2D

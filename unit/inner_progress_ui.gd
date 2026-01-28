@tool
extends Node2D
class_name GradientProgress2D


signal value_changed(_value: float)


@export_group("Texture")
@export var draw_center: bool = true:
	set(toggle):
		draw_center = toggle
		queue_redraw()
@export var progress_over: Texture2D
@export var progress_texture: Texture2D
@export var progress_under: Texture2D
@export var progress_color: Color = Color.RED:
	set(color):
		progress_color = color
		queue_redraw()
var _gradient_texture: ImageTexture = null

@export_group("Progress")
@export_range(0., 1., .001) var progress_value: float:
	set(value):
		progress_value = value
		value_changed.emit(value)
		queue_redraw()

@export_group("Gradient")
@export var gradient: bool = false:
	set(toggle):
		gradient = toggle
		queue_redraw()
@export var gradient_value: Gradient
@export_range(2, 16, 2) var step: int = 4:
	set(value):
		step = value
		if (value & (value - 1)) == 0:
			queue_redraw()


func _draw() -> void:
	var draw_point: Vector2 = Vector2.ZERO
	var draw_region: Vector2 = progress_texture.get_size()
	
	if draw_center:
		draw_point = - draw_region / 2.
	
	draw_texture(progress_under, draw_point)
	
	if gradient:
		_gradient_texture = _get_gradient_texture()
	
	draw_texture_rect(
		progress_texture if !gradient else _gradient_texture,
		Rect2(draw_point, Vector2(draw_region.x * progress_value, draw_region.y)),
		true,
		progress_color if !gradient else Color(1., 1., 1., 1.)
	)
	
	draw_texture(progress_over, draw_point)


func _get_gradient_texture() -> ImageTexture:
	var progress_texture_size: Vector2i = Vector2i(progress_texture.get_size())
	var progress_image: Image = progress_texture.get_image()
	var image: Image = Image.create_empty(progress_texture_size.x, progress_texture_size.y, false, Image.FORMAT_RGBA8)
	
	if (step & (step - 1)) == 0:
		for i: int in range(step):
			var start_pnt: float = float(i) / float(step)
			var next_dist: float = float(i + 1) / float(step)
			
			image.fill_rect(
				Rect2i(
					Vector2(start_pnt * progress_texture_size.x, 0.),
					Vector2(next_dist * progress_texture_size.x, progress_texture_size.y)
				),
				gradient_value.sample(next_dist)
			)

	progress_image.blend_rect_mask(image, progress_image, Rect2i(Vector2i.ZERO, progress_texture_size), Vector2i.ZERO)

	var texture: ImageTexture = ImageTexture.create_from_image(progress_image)
	return texture

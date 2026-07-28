# variable_statistics_progress.gd
@tool
extends Control


@export_range(1, 21, 2) var step: int = 11:
	set(val):
		step = clampi(val, 1, 21)
		queue_redraw()
@export var total_border: int = 20:
	set(val):
		total_border = val
		queue_redraw()
@export var negative_color: Color = Color.RED
@export var positive_color: Color = Color.AQUA
@export var center_color: Color = Color.ALICE_BLUE
@export var value: int = 0:
	set(val):
		var _min: int = int(- (step - 1) / 2.)
		var _max: int = int((step - 1) / 2.)
		value = clampi(val, _min, _max)
		queue_redraw()


func _draw() -> void:
	var border: float = float(total_border) / float(step - 2)
	var width: float = size.x / float(step - 2) - border 
	var height: float = size.y
	
	var _create_rect: Callable = func(idx: int) -> Rect2: return Rect2(
		Vector2((border * .5) + (border * float(idx)) + (width * float(idx)), 0.),
		Vector2(width, height)
	)
	
	var _center_idx: int = int((step - 2) / 2.)
	
	
	for i: int in range(step - 2):
		draw_rect(
			_create_rect.call(i) as Rect2, Color.WHITE, false
		)
	
	
	if value == 0:
		draw_rect(
			_create_rect.call(_center_idx) as Rect2, Color.WHITE, true
		)
	else:
		var is_positive: bool = value > 0
		var _arr: Array = range(_center_idx, _center_idx + value, -1 if value < 0 else 1)
		for i: int in _arr:
			draw_rect(
				_create_rect.call(i) as Rect2, positive_color if is_positive else negative_color, true
			)
	
	
	
	
	
	

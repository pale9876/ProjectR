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
	var width: float = size.x / float(step) - border 
	var height: float = size.y
	
	for i: int in range(step):
		var rect: Rect2 = Rect2(
			Vector2((border * float(i)) + (width * float(i)), 0.),
			Vector2(width, height)
		)
		var center_idx: int = int((step - 1) / 2.)
		var color: Color = center_color if center_idx == i else negative_color if i < center_idx else positive_color
		
		draw_rect(
			rect, color, true
		)
	
	

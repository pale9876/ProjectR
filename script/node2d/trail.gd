@tool
extends Path2D
class_name Trail


const TRAIL_WIDTH_CURVE: Curve = preload("uid://d13m0kwnrw5i7")


@export var execute: bool = false
@export var target: Node2D
@export var max_step: int = 8
@export var max_width: float = 32.


var _line: Line2D


func _init() -> void:
	if !Engine.is_editor_hint() and get_line() == null:
		_line = Line2D.new()
		_line.width = 0.
		_line.width_curve = TRAIL_WIDTH_CURVE
		_line.joint_mode = Line2D.LINE_JOINT_BEVEL
		_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		_line.end_cap_mode = Line2D.LINE_CAP_ROUND
		_line.name = &"Line2D"
		add_child(_line)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or !execute: return
	
	var line: Line2D = get_line()
	
	curve.add_point(target.global_position, Vector2(), Vector2(), curve.point_count)
	
	if curve.point_count > max_step:
		curve.remove_point(0)
	
	if curve.point_count > 2:
		var tessellate: PackedVector2Array = curve.tessellate_even_length(3, 8.)
		line.width = max_width * clampf(curve.get_baked_length() / max_width, 0., 1.)
		line.points = tessellate
	else:
		if line.get_point_count() > 0:
			line.remove_point(0)


func get_line() -> Line2D:
	var line: Node = get_node_or_null("Line2D")
	return _line if line == null else line

	

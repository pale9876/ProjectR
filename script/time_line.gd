# time_line.gd
@tool
extends Control


# Import
const Cursor: Script = preload("uid://dw0ekro1jqg25")
const ProdoTime: Script = preload("uid://bivf6bk5xsogl")

# PackedScene
const PRODO_TIME_SCENE: PackedScene = preload("uid://g2kwsjaxcvch")


# Const
const POSTPONE: int = 8


@export var back_color: Color = Color(0.424, 0.424, 0.424, 0.314)
@export var enable_frame_color: Color = Color(0.826, 1.0, 0.808, 0.278)

var separate: int = 45
var length: int = 240

# private
var _drag: bool = false

func _ready() -> void:
	set_timeline(120)


func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event is InputEventMouseButton:
		_drag = drag_started(event)
	
	if _drag:
		if event is InputEventMouseMotion:
			var cursor: Cursor = get_cursor()
			var point: float = event.global_position.x - global_position.x
			cursor.set_cursor(
				clampi(int(point / separate), 0, length)
			)


func _draw() -> void:
	var iter_max: int = length + POSTPONE
	
	# UI 길이
	draw_rect(
		Rect2(Vector2(), Vector2(float(iter_max * separate), 25.)),
		back_color
	)
	
	# 키 셋이 가능한 범위
	draw_rect(
		Rect2(Vector2(), Vector2(float((length) * separate), 25.)),
		enable_frame_color
	)
	
	for i: int in iter_max:
		draw_string(
			ThemeDB.fallback_font,
			Vector2(float(i * separate), 16.),
			str(i), HORIZONTAL_ALIGNMENT_LEFT,
			-1., 16, Color.WHITE, TextServer.JUSTIFICATION_NONE, TextServer.DIRECTION_LTR
		)


func set_timeline(_length: int = 60) -> void:
	length = _length
	custom_minimum_size = Vector2(float((length + POSTPONE) * separate), 25.)
	
	queue_redraw()


func drag_started(event: InputEventMouseButton) -> bool:
	return event.is_pressed() and !event.is_echo() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT


func get_cursor() -> Cursor:
	return get_node(^"Cursor") as Cursor



	

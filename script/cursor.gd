@tool
extends Control


# Import
const TimeLine: Script = preload("uid://vid40exokkq0")

@onready var v_box_container: VBoxContainer = %VBoxContainer2


var cursor: int = 0


func _draw() -> void:
	# draw cursor
	var timeline := get_timeline()
	var separate: int = timeline.separate
	var cursor_point_x := float(cursor * separate)
	
	draw_line(
		Vector2(cursor_point_x, 0.), # From
		Vector2(cursor_point_x, v_box_container.size.y),
		Color.WHITE,
		2.
	)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		pass


func set_cursor(val: int) -> void:
	cursor = val
	queue_redraw()


func get_timeline() -> TimeLine:
	return get_parent() as TimeLine

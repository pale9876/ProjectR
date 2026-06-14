# Example script for drawing custom elements. Interesting part is how to use the arguments provided for callbas.
@tool
extends MetroidvaniaSystem.CustomElementManager

func _init() -> void:
	register_element("Label", draw_label)


func draw_label(
	canvas_item: RID,
	coords: Vector3i,
	pos: Vector2,
	size: Vector2,
	data: String
):
	# The label is only visible if it's cell is discovered.
	if not MetSys.is_cell_discovered(coords):
		return
	# Draw the string.
	var font := ThemeDB.get_default_theme().default_font
	font.draw_string(canvas_item,
		pos + Vector2(-1, -0.5) * MetSys.CELL_SIZE, data, HORIZONTAL_ALIGNMENT_CENTER, MetSys.CELL_SIZE.x * 3)

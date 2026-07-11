extends Panel
class_name MapTile


enum Type {
	EMPTY,
	START_POINT,
}

@export var type: Type
@export var color: Color = Color.TRANSPARENT
@export_file() var scene: String

var init_pos: Vector2i = Vector2i()

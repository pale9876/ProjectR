# track_key_panel.gd
extends Panel


func set_track_label(track_name: String) -> void:
	get_label().text = track_name


func add_key(cursor: float, value: Variant) -> void:
	
	Vector2(cursor, size.y / 2.)


func get_label() -> Label:
	return get_node(^"Label") as Label

# prodo_time.gd
@tool
extends HBoxContainer


func set_time(val: int) -> void:
	var val_to_text: String = str(val)
	get_node(^"Label").text = val_to_text
	name = StringName(val_to_text)

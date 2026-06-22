@tool
extends LineEdit

@export var icon: String = "Node":
	set(value):
		icon = value
		_update_icon()

const theme_name: StringName = &"EditorIcons"

func _enter_tree():
	_update_icon()

func _update_icon():
	if has_theme_icon(icon, theme_name):
		right_icon = get_theme_icon(icon, theme_name)
	else:
		right_icon = null

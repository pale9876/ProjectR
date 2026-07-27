# class_list.gd
extends VBoxContainer


signal class_changed(_select: StringName)


# Import
const ClassSelectButton: Script = preload("uid://ptibopjrd7sc")


var _selected: ClassSelectButton = null:
	set(btn):
		if btn != _selected:
			_selected = btn
			class_changed.emit(btn.button_name)


func _ready() -> void:
	for node: Node in get_children():
		if node is ClassSelectButton:
			node.button_up.connect(
				func() -> void: # Toggle
					_selected = node
					for _node: Node in get_children():
						_node.button_pressed = (_selected == _node)
			)
			


	

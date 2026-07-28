# radio_button.gd
@tool
extends Button


# Import
const RadioButtonContainer: Script = preload("uid://dgxb13iyu7nlx")


func _init() -> void:
	toggle_mode = true
	button_pressed = false


var btn_up: Callable = func() -> void:
	(get_parent() as RadioButtonContainer).selected = self


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	var parent: Node = get_parent()
	if parent is RadioButtonContainer:
		if !parent.buttons.has(self):
			button_up.connect(btn_up)
			parent.buttons.push_back(self)


func _exit_tree() -> void:
	if Engine.is_editor_hint(): return
	
	var parent: Node = get_parent()
	if parent is RadioButtonContainer:
		if parent.buttons.has(self):
			button_up.disconnect(btn_up)
			parent.buttons.erase(self)

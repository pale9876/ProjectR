# radio_button_container.gd
@tool
extends VBoxContainer


signal toggled()



@export var init_pressed: String = ""
@export var separate: int = 8:
	set(val):
		separate = val
		add_theme_constant_override("separation", separate)


var buttons: Array[Button] = []
var selected: Button = null:
	set(btn):
		selected = btn
		toggled.emit()


func _ready() -> void:
	if !init_pressed.is_empty():
		var init_btn := get_button(NodePath(init_pressed))
		selected = init_btn
	
	
	toggled.connect(func() -> void: print(selected.name))
	


func get_button(button_name: NodePath) -> Button:
	return get_node(button_name) as Button

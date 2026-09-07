extends CheckBox
class_name IngameOptionCheckboxAttribute


@export var invert: bool = false
@export_multiline() var description: String
@export var sub_option_container: NodePath


func _init() -> void:
	toggled.connect(
		func (_toggle: bool) -> void:
			var sub_options := get_node_or_null(sub_option_container)
			var active: bool = is_active(_toggle)
			if sub_options and sub_options is VBoxContainer:
				sub_options.visible = active
				if active:
					for option: Node in sub_options.get_children():
						if option is CheckBox:
							option.button_pressed = false
				
	)


func _ready() -> void:
	mouse_entered.connect(
		func() -> void:
			var _description_text_label := get_description_label()
			if _description_text_label:
				_description_text_label.text = description
	)
	
	mouse_exited.connect(
		func() -> void:
			clear_label()
	)
	
	var _sub_option := get_node_or_null(sub_option_container)
	if _sub_option != null and _sub_option is VBoxContainer:
		_sub_option.visible = !button_pressed if invert else button_pressed


func get_description_label() -> RichTextLabel:
	var result := get_node_or_null(^"%OptionDescription")
	if result:
		return get_node_or_null(^"%OptionDescription") as RichTextLabel
	else:
		return null


func is_active(toggle: bool) -> bool:
	return !toggle if invert else toggle


func clear_label() -> void:
	var _description_text_label := get_description_label()
	if _description_text_label:
		_description_text_label.text = ""

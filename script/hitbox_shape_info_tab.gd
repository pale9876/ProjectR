# hitbox_shape_info_tab.gd
extends TabBar


@onready var hitbox_name: LineEdit = $VBoxContainer/HitboxName
@onready var delete: Button = $VBoxContainer/HFlowContainer/Delete


func _ready() -> void:
	hitbox_name.text_changed.connect(
		func (text: String) -> void:
			self.name = StringName(text)
	)
	
	delete.button_up.connect(
		func () -> void:
			pass
	)





	

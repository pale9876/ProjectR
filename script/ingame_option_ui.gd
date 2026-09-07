# ingame_option_ui.gd
extends Control


@onready var close_btn: Button = $PanelContainer/MarginContainer/VBoxContainer/HFlowContainer/Close


func _ready() -> void:
	close_btn.button_up.connect(
		func () -> void:
			visible = false
	)


func save_ingame_option() -> void:
	pass

# title.gd
extends CanvasLayer

# Import
const TitleUiButton: Script = preload("uid://chmqpyka2hi81")


@onready var start: Button = %Start
@onready var option: Button = %Option
@onready var map_editor: Button = %MapEditor


func _ready() -> void:
	start.button_up.connect(on_start_btn_pressed)
	map_editor.button_up.connect(
		func() -> void:
			pass
	)



func on_start_btn_pressed() -> void:
	GSignal.start.emit()

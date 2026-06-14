extends CanvasLayer


@onready var start: Button = %Start
@onready var option: Button = %Option


func _ready() -> void:
	start.button_up.connect(on_start_btn_pressed)
	



func on_start_btn_pressed() -> void:
	GSignal.start.emit()

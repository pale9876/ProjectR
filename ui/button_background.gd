@tool
extends TextureButton
class_name JoyStick


@export var stick_color: Color = Color.WHITE
@export var background_color: Color


func _draw() -> void:
	draw_circle(self.size / 2., self.size.x / 2., stick_color, false)
	

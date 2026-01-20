extends CanvasLayer
class_name ScreenJoystick


var _pressed: bool = false
var _point: Vector2 = Vector2.ZERO


@onready var stick: JoyStick = $Control/Stick


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		touch_ev_handler(event)
	elif event is InputEventScreenDrag:
		drag_ev_handler(event)



func touch_ev_handler(ev: InputEventScreenTouch) -> void:
	if ev.is_pressed():
		_pressed = true
		_point = ev.position
	elif ev.is_released():
		_pressed = false


func drag_ev_handler(ev: InputEventScreenDrag) -> void:
	pass

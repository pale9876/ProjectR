extends Control
class_name ScreenJoystick


@export_group("UI_Style")
@export var radius: float = 80.:
	set(value):
		radius = value
		queue_redraw()
@export_range(0., 1., .001) var inner_radius: float = .4:
	set(value):
		inner_radius = value
		queue_redraw()


@export var reset_curve: Curve

@export var stick_color: Color = Color.WHITE
@export var stick_line_color: Color = Color.YELLOW
@export var background_color: Color


var _pressed: bool = false

var _point: Vector2 = Vector2.ZERO:
	set(value):
		_point = value
		_inner_point = value
		queue_redraw()

var _inner_point: Vector2:
	set(value):
		_inner_point = value
		queue_redraw()

var _alpha: float = 0.:
	set(value):
		_alpha = value
		queue_redraw()


func _enter_tree() -> void:
	_point = size / 2.


func _draw() -> void:
	draw_circle( # draw background circle
		_point,
		radius,
		Color(stick_color, 1.),
		false
	)
	
	draw_circle( # draw stick circle fill
		_inner_point,
		radius * inner_radius,
		stick_color,
	)
	
	draw_circle(
		_inner_point,
		radius * inner_radius,
		Color(stick_line_color, 1.),
		false, 1.
	)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		touch_ev_handler(event)
	elif event is InputEventScreenDrag:
		drag_ev_handler(event)


func touch_ev_handler(ev: InputEventScreenTouch) -> void:
	if ev.is_pressed():
		if ev.button_index == MOUSE_BUTTON_LEFT:
			_pressed = true
			_point = ev.position
	elif ev.is_released():
		if ev.button_index == MOUSE_BUTTON_LEFT:
			_pressed = false
			_initialization_inner_point()


func drag_ev_handler(ev: InputEventScreenDrag) -> void:
	if _pressed:
		var dragged_pnt: Vector2 = ev.position
		var current_dist: float = ev.position.distance_squared_to(_point)
		if current_dist > radius ** 2:
			dragged_pnt = _point + _point.direction_to(dragged_pnt) * radius
		_inner_point = dragged_pnt


func _initialization_inner_point() -> void:
	var x_tween: Tween = create_tween()
	var y_tween: Tween = create_tween()

	x_tween.tween_property(
		self,
		"_inner_point:x",
		_point.x,
		.25
	).set_custom_interpolator(
		func(value: float): return reset_curve.sample_baked(value)
	)
				
	y_tween. tween_property(
		self,
		"_inner_point:y",
		_point.y,
		.25
	).set_custom_interpolator(
		func(value: float): return reset_curve.sample_baked(value)
	)

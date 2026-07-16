@tool
extends ProgressBar


@export var decay: float = .8
@export var max_offset: Vector2 = Vector2(25., 10.)
@export_tool_button("Shake", "2D") var _shake: Callable = shake_start


var origin: Vector2
var trauma: float = 0.
var power: int = 2


func _enter_tree() -> void:
	origin = position


func _process(_delta: float) -> void:
	if trauma > 0.:
		trauma = max(0., trauma - decay * _delta)
		shake()


func set_val(val: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "value", val, .35
	).set_ease(Tween.EASE_OUT_IN)


func shake_start(_trauma := 1.) -> void:
	trauma = min(_trauma + trauma, 1.)


func shake() -> void:
	var amount: float = pow(trauma, power)
	position.x = origin.x + (max_offset.x * amount * randf_range(-1., 1.))
	position.y = origin.y + (max_offset.y * amount * randf_range(-1., 1.))
	

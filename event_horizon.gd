extends Node


const DODGE_EV_TIME_SCALE_CURVE: Curve = preload("uid://cugxfaikkyq5j")


func player_dodged_ev(duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		Engine, "time_scale", .15, duration
	).set_custom_interpolator(
		func(value: float) -> float:
			return DODGE_EV_TIME_SCALE_CURVE.sample_baked(value)
	)
	await tween.finished
	Engine.time_scale = 1.

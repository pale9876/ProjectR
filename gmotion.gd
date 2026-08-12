# Gmotion
@tool
extends Node


signal global_motion_scale_changed()
signal player_motion_scale_changed()


var global_scale: float = 1.
var player_scale: float = 1.


func get_player_scale() -> float:
	return global_scale * player_scale


func set_global_scale(_scale: float, duration: float, ease_type: Tween.EaseType) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "global_scale", clampf(_scale, 0., 1.), duration
	).set_ease(ease_type)
	tween.step_finished.connect(
		func (_idx: int) -> void:
			global_motion_scale_changed.emit()
	)


func set_player_scale(val: float, duration: float, ease_type: Tween.EaseType) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "player_scale", clampf(val, 0., 3.), duration
	).set_ease(ease_type)
	tween.step_finished.connect(
		func (_idx: int) -> void:
			player_motion_scale_changed.emit()
	)

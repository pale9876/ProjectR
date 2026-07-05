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


func player_hit(hit_info: HitboxInformation) -> void:
	var player := Global.player
	await get_tree().physics_frame
	Global.get_ingame_scene().process_mode = Node.PROCESS_MODE_DISABLED
	player.get_camera().shake(
		Vector2(hit_info.force * hit_info.shake_strength), .55
	)
	await get_tree().create_timer(.05).timeout
	Global.get_ingame_scene().process_mode = Node.PROCESS_MODE_INHERIT
	

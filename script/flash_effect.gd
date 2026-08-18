extends Sprite2D


func _ready() -> void:
	($AnimationPlayer as AnimationPlayer).animation_finished.connect(
		func (_anim_name: StringName) -> void:
			queue_free.call_deferred()
	)


func set_effect(hit_result: HitResult) -> void:
	var _angle: float = hit_result.from.global_position.direction_to(hit_result.to.global_position).angle()
	
	rotation = _angle

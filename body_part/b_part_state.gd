# body_part/b_part_state.gd
extends LimboState


func _enter() -> void:
	pass


func _update(delta: float) -> void:
	pass


func get_anim() -> AnimationPlayer:
	return get_body().get_anim()


func get_body() -> BodyPart:
	return agent as BodyPart


func move_and_slide() -> bool:
	return get_body().move_and_slide()


func move(motion: Vector2, test: bool = false, _margin: float = .08, _recover: bool = false) -> KinematicCollision2D:
	return get_body().move_and_collide(motion, test, _margin, _recover)


func get_gravity() -> void:
	pass


func get_friction() -> void:
	pass


func play() -> void:
	pass

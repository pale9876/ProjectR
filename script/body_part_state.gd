# body_part/b_part_state.gd
extends LimboState
class_name BodyPartState


func get_anim() -> AnimationPlayer:
	return get_body().get_anim()


func play(anim_name: StringName) -> void:
	get_anim().play(anim_name)


func get_body() -> BodyPart:
	return agent as BodyPart


func move_and_slide() -> bool:
	return get_body().move_and_slide()


func move_and_collide(motion: Vector2, test: bool = false, _margin: float = .08, _recover: bool = false) -> KinematicCollision2D:
	return get_body().move_and_collide(motion, test, _margin, _recover)


func get_gravity(max_grav: float, delta: float) -> void:
	var body := get_body()
	body.velocity.y = move_toward(body.velocity.y, max_grav, delta)


func get_friction(delta: float) -> void:
	var body := get_body()
	body.velocity.x = move_toward(body.velocity.x, 0., delta)
	
	
	

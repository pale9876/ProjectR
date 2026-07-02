extends PlayerState


var idle_state: PlayerState
var jump_state: PlayerState
var fall_state: PlayerState


func approved_position() -> bool:
	var player := get_player()
	var param: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		player.global_position,
		player.global_position + Vector2(0., 600.),
		1, [player.get_rid()]
	)
	var result := player.get_world_2d().direct_space_state.intersect_ray(param)
	if !result.is_empty():
		var collision_point := result["position"] as Vector2
		var dist := collision_point.y - player.global_position.y
		print(dist)
		if collision_point.y - player.global_position.y > 70:
			return true
	
	
	return false


func _guard() -> bool:
	if (get_state_machine().get_active_state() in [jump_state, fall_state]) and approved_position():
		return true
	return false


func _enter_tree() -> void:
	init_action()


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")
	jump_state = get_state_machine().get_state(^"Jump")
	fall_state = get_state_machine().get_state(^"Fall")


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	var player := get_player()
	
	if !is_on_floor():
		player.velocity.y = move_toward(player.velocity.y, 970., 25.125)
	
	move_and_slide()
	
	

@tool
extends SubViewport


@export var _has_focused: bool = true

#func _process(delta: float) -> void:
	#if _has_focused:
		#var dir: Vector2 = get_input_vector()
		#
		#if dir != Vector2.ZERO:
			#camera.position += dir


func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("world_map_move_right") - Input.get_action_strength("world_map_move_left"),
		Input.get_action_strength("world_map_move_down") - Input.get_action_strength("world_map_move_up")
	)

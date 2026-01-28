@tool
extends Camera2D
class_name SceneCamera2D


@export var mover_per_second: float = 330.
@export var target: Node2D = null


func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if target != null:
		var target_pos: Vector2 = target.global_position
		global_position = global_position.move_toward(target_pos, mover_per_second * delta)

@tool
extends AudioStreamPlayer3D


@export var duration: float = -1.


func _enter_tree() -> void:
	play()
	
	if duration > 0.:
		await get_tree().create_timer(duration, false, false).timeout
		queue_free()
	else:
		await finished
		queue_free()

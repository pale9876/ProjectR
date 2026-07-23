extends Node



var pool: PackedInt32Array = PackedInt32Array()



func create_sprite_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	#frames.add_animation()
	#frames.add_frame()
	return frames


func add_task() -> int:
	var task_id: int = WorkerThreadPool.add_task(spawn_npc)
	
	return task_id


func spawn_npc() -> void:
	pass


func spawn_unit() -> void:
	pass


func spawn_event() -> void:
	pass


func spawn_squad() -> void:
	pass

extends CanvasLayer


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


#func _ready() -> void:
	#trace = Global.player
#
#
#func _process(_delta: float) -> void:
	#if trace.is_inside_tree():
		#listener.global_position = TargetStreamPlayer.pos_to_vec3(trace.global_position)


func play(stream: AudioStream, position: Vector2, bus: StringName = &"Master", _target: Node2D = null) -> void:
	var player := TargetStreamPlayer.new()
	player.stream = stream
	player.target = _target
	
	add_child(player)
	
	player.play()
	player.position = TargetStreamPlayer.pos_to_vec3(position, 0.)
	
	player.finished.connect(
		func() -> void:
			await get_tree().process_frame
			player.queue_free()
	)


func play_fx() -> void:
	pass


func play_bgm() -> void:
	pass


class TargetStreamPlayer extends AudioStreamPlayer3D:
	var target: Node2D
	
	func _process(_delta: float) -> void:
		if target:
			pos_to_vec3(target.global_position)

	static func pos_to_vec3(pos: Vector2, z_value: float = 0.) -> Vector3:
		return Vector3(pos.x, - pos.y, z_value) / 50.

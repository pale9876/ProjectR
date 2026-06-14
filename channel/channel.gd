extends CanvasLayer


@onready var listener: AudioListener3D = $Camera3D/AudioListener3D


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func play(stream: AudioStream, offset: float, position: Vector3) -> void:
	var player := AudioStreamPlayer3D.new()
	player.stream = stream
	player.play(offset)
	player.position = position


func pos_to_vec3(pos: Vector2, z_value: float) -> Vector3:
	return Vector3(pos.x, - pos.y, z_value)


func _process(delta: float) -> void:
	pass

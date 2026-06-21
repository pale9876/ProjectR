extends CanvasLayer


@export var trace: Node2D

@onready var listener: AudioListener3D = $Camera3D/AudioListener3D


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func _process(_delta: float) -> void:
	if trace:
		listener.global_position = TargetStreamPlayer.pos_to_vec3(trace.global_position)


func play(stream: AudioStream, position: Vector3, _target: Node2D = null) -> void:
	var player := TargetStreamPlayer.new()
	player.stream = stream
	player.target = _target
	add_child(player)
	player.play()
	player.position = position


class TargetStreamPlayer extends AudioStreamPlayer3D:
	var target: Node2D
	
	func _process(_delta: float) -> void:
		if target:
			pos_to_vec3(target.global_position)


	static func pos_to_vec3(pos: Vector2, z_value: float = 0.) -> Vector3:
		return Vector3(pos.x, - pos.y, z_value) / 50.

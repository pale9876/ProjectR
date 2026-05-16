@tool
extends Node


@export_tool_button("Play", "AudioStream") var _play: Callable = play
@export_tool_button("Stop", "Error") var _stop: Callable = stop


var _current: AudioStreamPlaybackPolyphonic


func play() -> void:
	print("Play")


func stop() -> void:
	_current.stop()


func _enter_tree() -> void:
	pass


class SpecimenAnim extends RefCounted:
	pass

extends Node


@export var audio: AudioStream


func _enter_tree() -> void:
	var playback: AudioStreamPlayback = audio.instantiate_playback()
	
	playback.start()
	await get_tree().create_timer(30.).timeout

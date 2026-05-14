@tool
extends KiraPlayer


func _enter_tree() -> void:
	var data: StaticSoundData = KiraAudioServer.create_data(
		"Ex01_SilentMadness"
	)
	sound_data = data

@tool
extends KiraPlayer


func _enter_tree() -> void:
	print(KiraAudioServer.get_list())

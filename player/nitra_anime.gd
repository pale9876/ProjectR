# nitra_anime.gd
@tool
extends AnimationPlayer


var freeze_frame: int = 0


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	for lib: StringName in get_animation_library_list():
		remove_animation_library(lib)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if freeze_frame == 0:
		if is_paused():
			play()
	else:
		freeze_frame -= 1


func freeze(frame: int) -> void:
	freeze_frame = maxi(frame, 0)
	pause()


func is_paused() -> bool:
	return !is_playing() and is_animation_active()


func is_freezed() -> bool:
	return freeze_frame > 0

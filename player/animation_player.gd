extends AnimationPlayer


var freeze_frame: int = 0


func _enter_tree() -> void:
	for lib: StringName in get_animation_library_list():
		remove_animation_library(lib)


func _physics_process(_delta: float) -> void:
	if freeze_frame == 0:
		var is_paused: bool = !is_playing() and is_animation_active()
		if is_paused:
			play()
	else:
		freeze_frame -= 1
	


func freeze(frame: int) -> void:
	freeze_frame = maxi(frame, 0)
	pause()

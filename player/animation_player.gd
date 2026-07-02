extends AnimationPlayer


func _enter_tree() -> void:
	for lib: StringName in get_animation_library_list():
		remove_animation_library(lib)

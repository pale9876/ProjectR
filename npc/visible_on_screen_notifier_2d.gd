extends VisibleOnScreenNotifier2D


func _enter_tree() -> void:
	visible = false
	screen_entered.connect(on_entered)
	screen_exited.connect(on_exited)


func on_entered() -> void:
	(get_parent() as Node2D).visible = true


func on_exited() -> void:
	(get_parent() as Node2D).visible = false

@tool
extends AudioListener3D


@export var trace: EEAD


func _enter_tree() -> void:
	make_current()


func _process(delta: float) -> void:
	if trace:
		global_position = trace.coordinate() / 10.

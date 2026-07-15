# spectre.gd
extends Camera2D



func _process(delta: float) -> void:
	if is_current():
		var direction := Input.get_vector("left", "right", "up", "down")

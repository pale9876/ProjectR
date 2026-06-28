extends Node


func _process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	print(Vector2(x_input, y_input))

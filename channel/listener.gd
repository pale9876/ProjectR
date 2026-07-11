extends AudioListener3D


@export var offset: Vector2 = Vector2(0., -64.)


var trace: Node2D


func _ready() -> void:
	trace = Global.player


func _process(_delta: float) -> void:
	if trace.is_inside_tree():
		global_position = Vector3(
			trace.global_position.x + offset.x,
			trace.global_position.y - offset.y,
			0.
		) / 50.

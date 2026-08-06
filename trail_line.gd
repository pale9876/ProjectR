@tool
extends Path2D


@export var line: Line2D


func _init() -> void:
	if !curve:
		curve = Curve2D.new()
	
	curve.changed.connect(
		func() -> void:
			_update()
	)


func _ready() -> void:
	_update()
	get_anim().play(&"wag_2")


func _update() -> void:
	var points: PackedVector2Array = curve.tessellate(4)
	
	if line:
		line.points = points


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer") as AnimationPlayer

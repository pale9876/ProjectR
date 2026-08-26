@tool
extends Path2D
class_name AnimatedTail


@export_tool_button("Insert Path Points", "AnimationPlayer")
var insert_path_points: Callable = AnimationTrackServer.insert_path_points.bind(self)


func _init() -> void:
	if !curve:
		curve = Curve2D.new()

	curve.changed.connect(
		func() -> void:
			_update()
	)


func _ready() -> void:
	_update()
	_play(&"wag")


func _play(anim_name: StringName) -> void:
	var anim: AnimationPlayer = get_anim()
	if anim.has_animation(anim_name):
		anim.play(anim_name)



func _update() -> void:
	var points: PackedVector2Array = curve.tessellate(4)
	
	get_line().points = points


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer") as AnimationPlayer


func get_line() -> Line2D:
	return get_node(^"Line2D") as Line2D




	

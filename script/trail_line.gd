@tool
extends Path2D


func get_line() -> Line2D:
	return get_node(^"Line2D") as Line2D


@export_tool_button("Insert Path Points", "AnimationPlayer")
var insert_path_points: Callable = func () -> void:
	var player := get_anim()
	var current_anim: StringName = player.assigned_animation
	var cursor: float = player.current_animation_position
	
	for i: int in curve.point_count:
		var _pos: Vector2 = curve.get_point_position(i)
		var _in: Vector2 = curve.get_point_in(i)
		var _out: Vector2 = curve.get_point_out(i)
		var path_base: String = ".:curve:point_%s/%s"
		
		var pos_track_path: String = path_base % [i, "position"]
		var in_track_path: String = path_base % [i, "in"]
		var out_track_path: String = path_base % [i, "out"]
		
		var anim: Animation = player.get_animation(current_anim)
		
		var pos_track_idx: int = get_anim_track_index(anim, pos_track_path)
		var in_track_idx: int = get_anim_track_index(anim, in_track_path)
		var out_track_idx: int = get_anim_track_index(anim, out_track_path)

		var pos_key_index: int = anim.track_insert_key(pos_track_idx, cursor, _pos)
		var in_key_index: int = anim.track_insert_key(in_track_idx, cursor, _in)
		var out_key_index: int = anim.track_insert_key(out_track_idx, cursor, _out)
		
		print(
			"Insert Keys => \n	%s => %s \n	 %s => %s \n 	%s => %s"
			% [
				pos_track_path, pos_key_index,
				in_track_path, in_key_index,
				out_track_path, out_key_index
			]
		)


func get_anim_track_index(anim: Animation, path: String) -> int:
	var result: int = anim.find_track(path, Animation.TYPE_VALUE)
	if result == -1:
		result = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(result, path)
		anim.track_set_interpolation_type(result, Animation.INTERPOLATION_NEAREST)
		anim.value_track_set_update_mode(result, Animation.UPDATE_DISCRETE)
		
	return result


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

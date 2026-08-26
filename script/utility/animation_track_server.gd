extends RefCounted
class_name AnimationTrackServer


static func insert_path_points(path_2d: Path2D) -> void:
	var player := path_2d.get_node(^"AnimationPlayer") as AnimationPlayer
	var current_anim: StringName = player.assigned_animation
	var cursor: float = player.current_animation_position
	
	for i: int in path_2d.curve.point_count:
		var _pos: Vector2 = path_2d.curve.get_point_position(i)
		var _in: Vector2 = path_2d.curve.get_point_in(i)
		var _out: Vector2 = path_2d.curve.get_point_out(i)
		var path_base: String = ".:curve:point_%s/%s"
		
		var pos_track_path: String = path_base % [i, "position"]
		var in_track_path: String = path_base % [i, "in"]
		var out_track_path: String = path_base % [i, "out"]
		
		var anim: Animation = player.get_animation(current_anim)
		
		var pos_track_idx: int = add_anim_track_index(anim, pos_track_path)
		var in_track_idx: int = add_anim_track_index(anim, in_track_path)
		var out_track_idx: int = add_anim_track_index(anim, out_track_path)

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

static func add_anim_track_index(anim: Animation, path: String) -> int:
	var result: int = anim.find_track(path, Animation.TYPE_VALUE)
	if result == -1:
		result = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(result, path)
		anim.track_set_interpolation_type(result, Animation.INTERPOLATION_NEAREST)
		anim.value_track_set_update_mode(result, Animation.UPDATE_DISCRETE)
		
	return result


	

@tool
extends Line2D
class_name CurvedLine


@export var path: Path2D


@export_range(0., 1., .001) var progress: float = 0.:
	set(val):
		progress = clampf(val, 0., 1.)
		var curve: PackedVector2Array = create_curve()
		if is_inside_tree():
			var _size: int = int(curve.size() * progress)
			var _result: PackedVector2Array = PackedVector2Array()
			for i: int in range(0, _size, 1):
				_result.push_back(curve[i])
			points = _result


func create_curve() -> PackedVector2Array:
	if !path: return []
	
	return path.curve.tessellate_even_length(4, 8.)

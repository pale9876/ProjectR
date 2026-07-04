@tool
extends UnitBTAction



func _generate_name() -> String:
	return "인식 영역 설정"


# [offset: Vector2, height: float, dist: float, range_ratio]
func get_info() -> Array:
	return []


func _enter() -> void:
	pass

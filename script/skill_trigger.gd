extends RefCounted
class_name SkillTrigger


var input_map: PackedStringArray
var cache: Dictionary[String, PackedStringArray] = {
	"direction" : PackedStringArray(),
	"action" : PackedStringArray(),
}
var duration: int = - 1


func _init(_input_map: PackedStringArray, _duration: int = -1) -> void:
	input_map = _input_map
	duration = _duration


func spend() -> bool:
	if (duration == -1 or duration > 0) and input_map == get_input_pool():
		clear()
		return true
	
	duration = maxi(0, duration - 1) if duration >= 0 else - 1
	return false


func clear() -> void:
	cache = {
		"direction" : PackedStringArray(),
		"action" : PackedStringArray()
	}


func get_input_pool() -> PackedStringArray:
	var pool: PackedStringArray = PackedStringArray()
	pool.append_array(cache["direction"])
	pool.append_array(cache["action"])
	return pool

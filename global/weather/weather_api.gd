extends Node


const WINTER_BRIGHTNESS_CURVE: Curve = preload("uid://dbugn338oegsq")


var step: float = 1.
var time_scale: float = 1.
var remainder: float = 0.


var _current_time: Dictionary = {}


func _enter_tree() -> void:
	var sys_time: Dictionary = Time.get_datetime_dict_from_system(true)
	# year, month, day, weekday, hour, minute, second, and dst (Daylight Savings Time).
	
	var year: int = sys_time["year"]
	var month: int = sys_time["month"]
	var day: int = sys_time["day"]
	var hour: int = sys_time["hour"]
	var minute: int = sys_time["minute"]
	var sec: int = sys_time["second"]
	
	_current_time = sys_time
	
	print(
		"Current Time  =>",
		year, "년 ",
		month, "월 ",
		day, "일 ",
		hour, "시간 ",
		minute, "분 ",
		sec, "초"
	)


func _process(delta: float) -> void:
	_elapsed(delta * time_scale)
	
	#_current_time = Time.get_datetime_dict_from_system(false)
	print(get_day_bright())
	
	#print(_current_time["second"], " 초")


func get_current_time() -> Dictionary: return _current_time


func get_day_bright() -> float:
	const max_day_bright: float = 60. * 60. * 24.
	
	if _current_time.is_empty(): return 0.
	
	var _hour: int = _current_time["hour"]
	var _minute: int = _current_time["minute"]
	var _second: int = _current_time["second"]
	
	var h_to_s: float = float(_hour) * 60. * 60.
	var m_to_s: float = float(_minute) * 60.
	var current_sec_value: float = float(_second) + h_to_s + m_to_s
	
	var result: float = current_sec_value / max_day_bright
	
	return WINTER_BRIGHTNESS_CURVE.sample_baked(result)


func _elapsed(sec: float) -> void:
	pass

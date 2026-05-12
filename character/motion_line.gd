@tool
extends Resource
class_name MotionDialogueLine

@export_group("Option")
@export var chained: bool = true

@export_group("Lines")
@export_multiline() var idle: PackedStringArray # 시전 전 대기
@export_multiline() var start: PackedStringArray # 모션 시작
@export_multiline() var hit: PackedStringArray # 모션 히트 시
@export_multiline() var missed: PackedStringArray # 모션 실패 시
@export_multiline() var engage: PackedStringArray # 모션 개시
@export_multiline() var finished: PackedStringArray # 마무리

@export_group("DEBUG")
@export_tool_button("Test Get Line", "TextFile")
var _test: Callable = test_get_line


# [idle, start, hit, missed, engage, finished]
func get_line(index: int = 0) -> PackedStringArray:
	var result: PackedStringArray = PackedStringArray()
	
	result.resize(6)
	
	var arr: Array[PackedStringArray] = [idle, start, hit, missed, engage, finished]
	
	if chained:
		for i: int in range(result.size()):
			result[i] = "" if arr[i].size() - 1 < index else arr[i][index]
	else:
		for i: int in range(result.size()):
			var rand_line: String = "" if arr[i].size() == 0 else arr[i][randi_range(0, arr[i].size())]
			result[i] = rand_line

	return result


func test_get_line() -> void:
	print(get_line())

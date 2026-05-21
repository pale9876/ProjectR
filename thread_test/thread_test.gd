extends Node


var arr: Array = [1, 2, 3, 4, 5]


func _ready() -> void:
	var tid: int = WorkerThreadPool.add_group_task(
		prx, arr.size()
	)
	
	WorkerThreadPool.wait_for_group_task_completion(tid)



func prx(p_idx: int) -> void:
	print_hello(arr[p_idx])


func print_hello(value: int) -> void:
	print("pass => %d" % value)

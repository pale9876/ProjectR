extends Resource


@export var event: Dictionary[StringName, PackedStringArray]


func get_dialog(ev: StringName) -> String:
	var rand_idx: int = randi_range(0, event[ev].size() - 1)
	return event[ev][rand_idx]

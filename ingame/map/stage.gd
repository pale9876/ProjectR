extends NPCPath
class_name Stage


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


@export var z_min: float = 0.
@export var z_max: float = 100.


func _process(delta: float) -> void:
	sort_units()


func swap(a: Node, b: Node) -> void:
	var a_idx: int = a.get_index()
	var b_idx: int = b.get_index()
	
	move_child(b, a_idx)
	move_child(a, b_idx)


func sort_units() -> Array[Replicator]:
	var _arr: Array[Replicator] = []
	
	for node: Node in get_children():
		if node is Replicator:
			_arr.push_back(node)
	
	_arr.sort_custom(
		func(a: Replicator, b: Replicator) -> bool:
			var result: bool = a.z_value < b.z_value
			if result:
				swap(a, b)
			return result
	)
	
	return _arr

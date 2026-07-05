extends NPCPath
class_name Stage


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


@export var z_min: float = 100.
@export var z_max: float = 300.


#func _process(delta: float) -> void:
	#var sort := get_units()
	#
	#for i: int in sort.size():
		#move_child(sort[i], i)
#
#
#func get_units() -> Array[Node2D]:
	#var result: Array[Node2D] = []
	#
	#for node: Node in get_children():
		#if (node is Unit) or (node is Player) or (node is NPC):
			#result.push_back(node)
	#
	#result.sort_custom(
		#func(a: Node2D, b: Node2D) -> bool:
			#return a.z_value < b.z_value
	#)
	#
	#return result

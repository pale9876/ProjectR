# karada_moduler.gd
@tool
extends Node2D


enum PartsOrder
{
	DEFAULT,
	HIGH_KICK,
	LEFT_HAND_BACK,
	RIGHT_HAND_BACK,
	BOTH_HAND_LEFT,
	BOTH_HAND_RIGHT,
}


@export var ORDER_BY_PARTS: Dictionary[PartsOrder, PackedStringArray] = {}


@export var order: PartsOrder = PartsOrder.DEFAULT:
	set(type):
		order = type
		ordering_parts(order)


@export_range(-1, 1, 2) var direction: int = 1:
	set(val):
		if direction != val and is_node_ready() and direction != 0:
			direction = val
			for node: Node in get_children():
				if node.name == &"Head":
					for head_part: Node in node.get_children():
						(head_part as DirectionSpriteModuler).direction = direction
					face_dir_order()
				elif node is DirectionSpriteModuler:
					node.direction = direction
			ordering_parts(order)


func _enter_tree() -> void:
	ORDER_BY_PARTS = { # 우측기준
		PartsOrder.DEFAULT : [
			"BackHair",
			"BodyBackRace",
			"RightArm",
			"Leg",
			"Body",
			"LeftArm",
			"Head",
		],
	}

func _ready() -> void:
	order = PartsOrder.DEFAULT


func order_place_arm_by_dir(order_type: PartsOrder) -> PackedStringArray:
	var result: PackedStringArray = PackedStringArray()
	
	if !ORDER_BY_PARTS.has(order_type):
		return []
	
	var values: PackedStringArray = ORDER_BY_PARTS[order_type]
	
	result.resize(values.size())
	
	for index: int in range(result.size()):
		var _str: String = values[index]
		if direction == -1:
			if _str == "RightArm":
				result[index] = "LeftArm"
			elif _str == "LeftArm":
				result[index] = "RightArm"
			else:
				result[index] = _str
		else:
			result[index] = _str

	return result


func face_dir_order() -> void:
	var left_side_tail: Node = get_head().get_node(^"LeftSideTail")
	var right_side_tail: Node = get_head().get_node(^"RightSideTail")
	var _head: Node = get_head()
	
	if direction == 1:
		if left_side_tail.get_index() != 2:
			_head.move_child(left_side_tail, 2)
		if right_side_tail.get_index() != 0:
			_head.move_child(right_side_tail, 0)
	elif direction == -1:
		if left_side_tail.get_index() != 0:
			_head.move_child(left_side_tail, 0)
		if right_side_tail.get_index() != 2:
			_head.move_child(right_side_tail, 2)


func ordering_parts(_order: PartsOrder) -> void:
	if !is_node_ready(): return
	
	var parts_order: PackedStringArray = order_place_arm_by_dir(order)
	
	if parts_order.is_empty(): return
	
	for index: int in range(get_child_count()):
		var node_name: StringName = get_child(index).name
		var cursor: String = parts_order[index]
		if node_name != StringName(cursor):
			move_child(get_node(NodePath(cursor)), index)


func get_head_parts() -> Array[Node]:
	return get_head().get_children()


func get_head() -> Node:
	return get_node(^"Head")
	
	
	

@tool
extends Node2D
class_name Stage


@export var disabled: bool = false
@export var size: Vector2 = Vector2(1., 1.)


@export var entrance_point: Array[Node2D]


@export_group("스폰포인트")
@export var spawn_point: Array[Node2D] = []


func _draw() -> void:
	pass


func _notification(what: int) -> void:
	if NOTIFICATION_CHILD_ORDER_CHANGED == what:
		for node: Node in get_children():
			if node is StaticBody2D:
				pass
			
			if node is IconPoint2D:
				pass

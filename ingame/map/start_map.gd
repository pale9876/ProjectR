# map.gd
extends Node2D
class_name Map


@export var start_spawn_position: Marker2D
@export var stage: Stage
@export var size: Vector2i = Vector2i.ONE:
	set(value):
		size = value.maxi(0)
@export var location: Vector2i:
	set(value):
		location = value.maxi(0)



func add_unit(node: Node2D) -> void:
	stage.add_child(node)


func get_stage() -> Stage:
	return get_node(^"Stage") as Stage


func get_world():
	return get_parent()


func get_keikai():
	return get_world().get_parent()


	

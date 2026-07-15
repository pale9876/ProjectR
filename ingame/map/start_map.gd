# map.gd
extends Node2D
class_name Map




signal location_changed()


@export var start_spawn_position: Marker2D
@export var stage: Stage


var location: Vector2i:
	set = set_location


func set_location(to: Vector2i) -> void:
	location = to
	location_changed.emit()


func add_unit(node: Node2D) -> void:
	stage.add_child(node)


func get_stage() -> Stage:
	return get_node(^"Stage") as Stage


func get_world():
	return get_parent()


func get_keikai():
	return get_world().get_parent()


	

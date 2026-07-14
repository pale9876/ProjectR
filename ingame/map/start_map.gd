# map.gd
extends Node2D
class_name Map


# Import
const MapKeikai: Script = preload("uid://o348jlsiq2tc")

signal location_changed()


@export var start_spawn_position: Marker2D
@export var keikai: StaticBody2D

@export var stage: Stage

@export var map_size: Vector2i = Vector2i.ONE

var location: Vector2i:
	set = set_location


func set_location(to: Vector2i) -> void:
	location = to
	location_changed.emit()


func add_unit(node: Node2D) -> void:
	stage.add_child(node)


func get_keikai_rect() -> Rect2:
	return Rect2(global_position, Vector2(get_keikai().width, get_keikai().height))


func get_keikai() -> MapKeikai:
	return get_node(^"Keikai") as MapKeikai



	

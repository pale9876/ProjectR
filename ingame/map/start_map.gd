# map.gd
extends Node2D
class_name Map


@export var start_spawn_position: Marker2D

@export var stage: Stage


func add_unit(node: Node2D) -> void:
	stage.add_child(node)

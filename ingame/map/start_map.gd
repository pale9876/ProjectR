# map.gd
extends Node2D


@export var start_spawn_position: Marker2D

@export var stage: Node2D


func add_unit(node: Node2D) -> void:
	stage.add_child(node)

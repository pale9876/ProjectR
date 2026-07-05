extends Node2D


@export var camera: Camera2D


func _process(delta: float) -> void:
	if Global.player:
		camera.position = Global.player.position

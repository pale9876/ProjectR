@tool
extends Endeka
class_name Ingame


@export var player: Player
@export var legion: Legion
@export var camera: MultiCamera


func _enter_tree() -> void:
	Global.player = player
	Global.camera = camera

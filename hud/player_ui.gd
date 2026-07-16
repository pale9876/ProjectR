# player_ui.gd
extends Control


# Import
const AnimatedProgress: Script = preload("uid://ln3jaqsdqoe8")


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func get_hp() -> AnimatedProgress:
	return get_node(^"%HP") as AnimatedProgress


func get_blood() -> AnimatedProgress:
	return get_node(^"%Blood") as AnimatedProgress


func get_first_roar() -> TextureRect:
	return get_node(^"%FirstRoar") as TextureRect


func get_second_roar() -> TextureRect:
	return get_node(^"%SecondRoar") as TextureRect

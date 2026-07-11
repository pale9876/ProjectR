# player/health.gd
extends ProgressBar

const Player: Script = preload("uid://c2uxhumgng18h")


func _enter_tree() -> void:
	var player := get_parent() as Player
	player.get_stat().damaged.connect(_damaged)


func _damaged() -> void:
	pass

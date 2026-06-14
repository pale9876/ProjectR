# player_ui.gd
extends Control


@onready var progress: TextureRect = %Progress
@onready var mp: ProgressBar = %Mp


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

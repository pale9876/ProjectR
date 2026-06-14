# hud.gd
extends CanvasLayer


# Import
const DialogUI: Script = preload("uid://borjea45xky04")


@onready var player_ui: Control = %PlayerUI
@onready var dialog_ui: DialogUI = %DialogUI


func _ready() -> void:
	player_ui.show()
	dialog_ui.hide()
	
	#Global.player.damaged.connect(_player_damaged)

func _player_damaged() -> void:
	pass

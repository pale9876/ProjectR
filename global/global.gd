extends Node


const SCREEN_JOY_PAD: PackedScene = preload("uid://bk1bnhqoyyuuj")


enum {
	INIT,
	READY,
	INGAME,
}


var state: int = INIT
var os: String = ""

var screen_joypad: CanvasLayer = null
var main_scene: Node = null


func _enter_tree() -> void:
	os = OS.get_name()
	if os == "Windows":
		pass
	elif os == "Android":
		screen_joypad = SCREEN_JOY_PAD.instantiate()
		
	elif os == "Web":
		pass


func _ready() -> void:
	pass


class SaveData extends Resource:
	pass

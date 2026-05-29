extends Node


const AASO_PLAYER: PackedScene = preload("uid://dudg0nhdnm0ou")
const TMBD_PLAYER: PackedScene = preload("uid://yvxdyisxykhj")


const AASO_MAIN_SCENE: Script = preload("uid://i4ng1cjfqvv6")
const TMBD_MAIN_SCENE: Script = preload("uid://c1eyse278nyf6")


enum State {
	INIT,
	READY,
	INGAME,
}


enum Class {
	PREDETOR = 0,
	TRICKSTER = 1,
	EXECUTIONER = 2,
	PUPPETEER = 3,
}


const INIT: State = State.INIT
const READY: State = State.READY
const INGAME: State = State.INGAME


const PREDETOR: Class = Class.PREDETOR
const TRICKSTER: Class = Class.TRICKSTER
const EXECUTIONER: Class = Class.EXECUTIONER
const PUPPETEER: Class = Class.PUPPETEER


signal start()
signal restart()

signal player_health_changed( value: float )
signal change_camera( cam_name: String )

signal default()


var os: String = ""
var player: Node


func _enter_tree() -> void:
	os = OS.get_name()
	print("구동환경: ", os)

	match os:
		_:
			pass


func _ready() -> void:
	pass



func process() -> void:
	pass


class SaveData extends Resource:
	pass

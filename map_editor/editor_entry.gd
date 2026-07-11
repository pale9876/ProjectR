extends PanelContainer



const DEFAULT_FOLDER: String = "user://"


@onready var create: Button = %Create
@onready var exit: Button = %Exit


func _init() -> void:
	visible = true



func _ready() -> void:
	create.button_up.connect(_create_pressed)
	exit.button_up.connect(_exit)


func _create_pressed() -> void:
	pass


func _exit() -> void:
	pass

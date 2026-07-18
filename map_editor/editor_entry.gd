extends PanelContainer


const DEFAULT_FOLDER: String = "user://"
const DEFAULT_SAVE_DIR: String = "res://map_editor/"


#@onready var create: Button = %Create
#@onready var exit: Button = %Exit


func _init() -> void:
	visible = true


func get_files() -> void:
	ResourceLoader.list_directory("user://")

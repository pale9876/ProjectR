extends Node

# Save Path
const PATH: String = "user://"
const DEFAULT_SAVE_FOLDER_PATH: String = "user://save/"


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const MainScene: Script = preload("uid://cplgj2iixr7f6")
const PlayerCamera: Script = preload("uid://b7phyhue4y3yg")
const Hud: Script = preload("uid://dgntyiu05self")
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const Channel: Script = preload("uid://bc33hejnp7byc")


# Scene
const PLAYER_SCENE: PackedScene = preload("uid://br4srsyh160du")


signal debug_toggled()


var data: Data
var player: Player
var player_camera: PlayerCamera

var current_data_name: String

var main_scene: MainScene


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = PLAYER_SCENE.instantiate() as Player
	#player_camera = PlayerCamera.new()


func _enter_tree() -> void:
	get_tree().set_auto_accept_quit(false)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			pass



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		debug_toggled.emit()



func load_data(save_file_name: String = "autosave") -> void:
	var save_path: String = DEFAULT_SAVE_FOLDER_PATH + save_file_name
	var exist: bool = ResourceLoader.exists(save_path)
	var res := ResourceLoader.load(save_path, "Data")



func start_dialog(
	with: NPC,
	d_line: String,
	init_str: String,
	soft_pause: bool = true
) -> void:
	with.get_screen_transform()
	var player_dialog_parent: Control = main_scene.get_dialog_ui().set_dialog_parent(
		player.get_screen_transform().origin, Vector2(0., - 32.)
	)
	var npc_dialog_parent: Control = main_scene.get_dialog_ui().set_dialog_parent(
		with.get_screen_transform().origin, Vector2(0., - 32.)
	)
	
	var d_parent_data: Dictionary[String, Control] = {
		"mumei_nanashi" : player_dialog_parent,
		"sample_npc" : npc_dialog_parent,
	}
	
	SproutyDialogs.start_dialog(
		with.dialog_data[d_line], init_str, {}, d_parent_data
	)
	
	if soft_pause:
		GSignal.soft_pause.emit()
		
		await SproutyDialogs.dialog_ended
		GSignal.resume.emit()
		
		player_dialog_parent.queue_free()
		npc_dialog_parent.queue_free()


func get_channel() -> Channel:
	return main_scene.channel


func get_ingame_scene() -> Ingame:
	return main_scene.ingame


func get_hud() -> Hud:
	return main_scene.hud


class Data extends Resource:
	var character: PlayerInformation
	var stat: Dictionary
	var stage: int
	var position: Vector2

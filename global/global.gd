extends Node

# Save Path
const PATH: String = "user://"


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const NPC: Script = preload("uid://btmmen2m5ofg7")
const MainScene: Script = preload("uid://cplgj2iixr7f6")


# Scene
const PLAYER_SCENE: PackedScene = preload("uid://br4srsyh160du")



var data: Data
var player: Player

var current_data_name: String

var main_scene: MainScene


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = PLAYER_SCENE.instantiate() as Player


func _enter_tree() -> void:
	#player = PLAYER_SCENE.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	pass


func _process(delta: float) -> void:
	#ResourceLoader.load_threaded_get_status(PATH + current_data_name + ".tres", [])
	pass


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


class Data extends Resource:
	var character: PlayerInformation
	var stat: Dictionary
	var stage: int
	var position: Vector2

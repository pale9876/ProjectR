extends Node2D
class_name TraitorMustBeDead


@export var player: Player
@export var legion: Legion
@export var camera: MultiCamera


@onready var ingame_canvas: CanvasLayer = $Ingame
@onready var title: CanvasLayer = %Title
@onready var hud: CanvasLayer = $HUD


# Player UI
@onready var character_icon: CharacterProfile = %CharacterIcon
@onready var hp_progress: GradientProgress = %HpProgress



func _ready() -> void:
	title.show()
	ingame_canvas.hide()
	hud.hide()
	#select_class.hide()
	
	ingame_canvas.process_mode = Node.PROCESS_MODE_DISABLED
	legion.target = player
	player.transform = Transform2D(0., Vector2(640., 360.) / 2.)
	character_icon.texture = player.unit_information.icon
	
	Global.player_health_changed.connect(_on_player_health_changed)
	Global.start.connect(start)



func start() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_INHERIT
	
	title.hide()
	ingame_canvas.show()
	hud.show()
	
	# Set Player Camera
	camera.add_cam(
		"player", player.global_position, 1.75, player, Color(0.398, 0.428, 0.48, 0.271)
	)
	camera.current = "player"
	
	legion.create()


func end() -> void:
	ingame_canvas.process_mode = Node.PROCESS_MODE_DISABLED


func _on_player_health_changed(value: float) -> void:
	var progress: float = float(player.unit_information.hp) / float(player.unit_information.max_hp)
	hp_progress.change_value(progress)

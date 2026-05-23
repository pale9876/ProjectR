extends Node2D
class_name TraitorMustBeDead


@onready var ingame: Ingame = $Ingame
@onready var title: CanvasLayer = %TitleScene
@onready var hud: CanvasLayer = $HUD


# Player UI
@onready var character_icon: CharacterProfile = %CharacterIcon
@onready var hp_progress: GradientProgress = %HpProgress
@onready var channel: Channel = $Channel



func _ready() -> void:
	title.show()
	ingame.hide()
	hud.hide()
	#select_class.hide()
	
	ingame.process_mode = Node.PROCESS_MODE_DISABLED
	ingame.legion.target = ingame.player
	ingame.player.transform = Transform2D(0., Vector2(640., 360.) / 2.)
	#character_icon.texture = player.unit_information.icon
	
	Global.player_health_changed.connect(_on_player_health_changed)
	Global.start.connect(start)
	
	#channel.listener.trace = player



func start() -> void:
	Global.ingame.process_mode = Node.PROCESS_MODE_INHERIT
	
	title.hide()
	ingame.show()
	hud.show()
	
	# Set Player Camera
	if Global.player != null:
		Global.camera.add_cam(
			"player",
			Global.player.position,
			1.75,
			Global.player,
			Color(0.398, 0.428, 0.48, 0.271)
		)
	

	Global.camera.current = "player"
	
	ingame.legion.create()


func end() -> void:
	ingame.process_mode = Node.PROCESS_MODE_DISABLED


func _on_player_health_changed(value: float) -> void:
	var current: int = Global.player.stat.hp
	var max_hp: int = Global.player.stat.max_hp
	var progress: float = float(current) / float(max_hp)
	hp_progress.change_value(progress)

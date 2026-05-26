extends Node2D
class_name TraitorMustBeDead


@onready var background: Endeka = $Background
@onready var ingame: Ingame = $Ingame
@onready var title: Title = %TitleScene
@onready var hud: HUD = $HUD
@onready var channel: Channel = $Channel


# Player UI
#@onready var character_icon: CharacterProfile = %CharacterIcon
#@onready var hp_progress: GradientProgress = %HpProgress



func _ready() -> void:
	title.show()
	background.propagate_hide()
	ingame.propagate_hide()
	hud.hide()
	#select_class.hide()
	
	ingame.process_mode = Node.PROCESS_MODE_DISABLED
	#ingame.legion.target = ingame.player
	ingame.player.transform = Transform2D(0., Vector2(640., 360.) / 2.)
	#character_icon.texture = player.unit_information.icon
	
	Global.player_health_changed.connect(_on_player_health_changed)
	Global.start.connect(start)
	
	channel.listener.trace = Global.player


func start() -> void:
	Global.ingame.process_mode = Node.PROCESS_MODE_INHERIT
	
	title.hide()
	background.propagate_show()
	ingame.propagate_show()
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
	
	hud.hp_progress.change_value(progress)

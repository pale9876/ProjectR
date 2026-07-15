# player.gd
extends Replicator


# Import
const PlayerCamera: Script = preload("uid://b7phyhue4y3yg")

@export_category("Data")
@export var info: PlayerInformation


@export_group("Debug")
@export var toggles: Array[Node]

var input_state: InputState

@onready var drop_shadow: Sprite2D = $DropShadow


var _prefix: StringName = &""


func get_stat() -> Stat:
	return stat


func _init() -> void:
	super()
	
	input_state = InputState
	state.face_changed.connect(_on_face_changed)


func _on_face_changed() -> void:
	if state.face.x != 0:
		get_sprite_component().scale.x = state.face.x


func _enter_tree() -> void:
	GSignal.soft_pause.connect(soft_pause)
	GSignal.resume.connect(resume)
	
	Global.debug_toggled.connect(
		func() -> void:
			for node: Node in toggles:
				if node is Node2D or node is Control:
					node.hide()
	)

func _ready() -> void:
	if info:
		stat.name = name
		stat.hp = info.hp
		stat.speed = info.speed
		
		get_sprite_component().init_sprites(
			info.upper_sprite,
			info.lower_sprite,
			info.sprite
		)
	
	var state_machine := get_state_machine() as StateMachine
	var idle_state := state_machine.get_state(^"Idle")
	state_machine.initial_state = idle_state
	state_machine.initialize(self)
	state_machine.set_active(true)


func _process(_delta: float) -> void:
	# Input
	input_state.direction = Input.get_vector("left", "right", "up", "down")


func get_face() -> float:
	return float(state.face.x)


func get_camera() -> PlayerCamera:
	return Global.player_camera

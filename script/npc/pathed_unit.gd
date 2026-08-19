extends PathFollow2D
class_name NPC


@export var info: UnitInformation
@export var z_value: float = 0.


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bt: BTPlayer = $BTPlayer
@onready var hsm: LimboHSM = $LimboHSM


var stat: Stat = Stat.new()


func _ready() -> void:
	stat.hp = info.hp
	stat.speed = info.speed
	stat.name = info.name


func get_stage() -> Stage:
	return get_parent() as Stage

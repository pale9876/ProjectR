extends PathFollow2D


@export var info: UnitInformation
@export var z_value: float = 0.

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bt: BTPlayer = $BTPlayer


var stat: Stat = Stat.new()


func _ready() -> void:
	stat.hp = info.hp
	stat.speed = info.speed
	stat.name = info.name


func get_root() -> NPCPath:
	return get_parent() as NPCPath


class Stat:
	var name: StringName
	var hp: int
	var speed: float

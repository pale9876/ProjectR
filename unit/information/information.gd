# information.gd for unit.stat
extends Resource
class_name UnitInformation


@export_group("Stats")
@export var name: StringName = &""
@export var speed: float = 200. # px / sec
@export var hp: int = 100


@export_group("SpriteFrames")
@export var upper_motions: SpriteFrames
@export var lower_motions: SpriteFrames
@export var sprite_frames: SpriteFrames

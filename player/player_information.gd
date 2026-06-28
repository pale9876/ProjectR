extends Resource
class_name PlayerInformation


@export var level: int = 0
@export var name: StringName = &""
@export var speed: float = 300.
@export var hp: int = 1000


@export_category("Sprite Frames Group")
@export var upper_sprite: SpriteFrames
@export var lower_sprite: SpriteFrames
@export var sprite: SpriteFrames

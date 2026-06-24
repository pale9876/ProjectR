extends Resource
class_name HitboxInformation



enum {
	KNOCkBACK,
	AERIAL,
}

@export var atk_name: StringName = &""
@export var damage: int = 10
@export var force: Vector2 = Vector2(200., 0.)
@export var blockable: bool = true
@export var trace: bool = true

extends CollisionPolygon2D
class_name HitPolygon


@export var offset: float = 62.
@export var height: float = 62.
@export var hit_range: float = 300.

@export var hitbox_info: HitboxInformation


func _init() -> void:
	visible = false
	disabled = true


func set_collision() -> void:
	pass

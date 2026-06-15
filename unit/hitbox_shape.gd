extends CollisionShape2D
class_name HitboxShape


@export var hitbox_info: HitboxInformation
var hit_result: HitResult = null


func _init() -> void:
	disabled = true
	visible = false

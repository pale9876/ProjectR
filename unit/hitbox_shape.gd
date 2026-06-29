extends CollisionShape2D
class_name HitboxShape



@export var hitbox_info: HitboxInformation


var result: Array[HitResult] = []


func _init() -> void:
	disabled = true
	visible = false


func push_result(_result: HitResult) -> void:
	if hitbox_info.max_available_unit_hit_count < result.size():
		result.push_back(_result)


func clear() -> void:
	result.clear()

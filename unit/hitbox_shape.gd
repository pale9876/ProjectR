extends CollisionShape2D
class_name HitboxShape




@export var hitbox_info: HitboxInformation
var result: HitResult = null



func _init() -> void:
	disabled = true
	visible = false


func result_free() -> void:
	result = null

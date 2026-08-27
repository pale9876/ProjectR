@icon("uid://beciwjrmhkiw6")
@tool
extends CollisionShape2D
class_name HitboxShape



@export var blade_stat: BladeModuleStat


var result: Array[HitResult] = []



func _init() -> void:
	if Engine.is_editor_hint(): return
	
	disabled = true
	visible = false


func push_result(_result: HitResult) -> void:
	#if result.size() < hitbox_info.max_available_unit_hit_count:
		#result.push_back(_result)
	# TODO
	pass


func clear() -> void:
	result.clear()

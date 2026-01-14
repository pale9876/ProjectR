@tool
extends Area2D
class_name Hurtbox2D


var _root: Node = null

@export_flags_2d_physics var mask: int = 0: set = set_mask


func _init() -> void:
	monitorable = false
	collision_layer = 0


func _enter_tree() -> void:
	_root = get_parent()

	if !Engine.is_editor_hint():
		area_entered.connect(on_area_entered)


func _process(delta: float) -> void:
	if _root is Node2D:
		visible = _root.visible


func on_area_entered(area: Area2D) -> void:
	pass


func set_mask(value: int) -> void:
	mask = value
	collision_mask = mask

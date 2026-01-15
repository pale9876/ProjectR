@tool
extends Area2D
class_name Hurtbox2D


var _root: Node = null

@export_flags_2d_physics var mask: int = 0: set = set_mask


func _init() -> void:
	monitoring = false
	monitorable = true
	collision_layer = 0


func _enter_tree() -> void:
	_root = get_parent()

	if !Engine.is_editor_hint():
		area_entered.connect(on_area_entered)
		area_exited.connect(on_area_exited)


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		monitorable = visible
		
		for node: Node in get_children():
			if node is Node2D:
				node.visible = visible



func on_area_entered(area: Area2D) -> void:
	pass


func on_area_exited(area: Area2D) -> void:
	pass


func set_mask(value: int) -> void:
	mask = value
	collision_mask = mask

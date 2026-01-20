@tool
extends Node2D
class_name Pose2D


var agent: Node = null


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		_visible_changed()
	elif what == NOTIFICATION_PATH_RENAMED:
		_renamed()


func _renamed() -> void:
	var parent: Node = get_parent()
	if parent is PoseController2D:
		parent._updated()


func _visible_changed() -> void:
	for node: Node in get_children():
		node.visible = visible


func _enter_tree() -> void:
	assert(get_parent() is PoseController2D)


# OVERRIDE
func _enter() -> void:
	pass


# OVERRIDE
func _update(_delta: float) -> void:
	pass


# OVERRIDE
func _exit() -> void:
	pass


func get_controller() -> PoseController2D:
	return get_parent() as PoseController2D

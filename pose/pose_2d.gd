@tool
extends Node2D
class_name Pose2D


@export var disabled: bool = false: set = _set_disabled


var _root: Node = null


func _set_disabled(toggle: bool) -> void:
	disabled = toggle
	self.visible = false


# OVERRIDE
func _enter() -> void:
	pass


# OVERRIDE
func _update(_delta: float) -> void:
	pass


# OVERRIDE
func _exit() -> void:
	pass



func _process(_delta: float) -> void:
	if _root != null:
		if _root is Node2D and !disabled:
			self.visible = _root.visible

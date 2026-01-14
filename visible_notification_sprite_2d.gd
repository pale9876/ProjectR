@tool
extends Sprite2D
class_name VisibleNotificationSprite2D


var _root: Node


func _enter_tree() -> void:
	_root = get_parent()
	
	if _root != null:
		if _root is Node2D:
			self.visible = _root.visible

func _process(delta: float) -> void:
	if _root is Node2D:
		self.visible = _root.visible

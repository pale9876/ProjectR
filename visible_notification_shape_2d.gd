@tool
extends CollisionShape2D
class_name VisibleNotificationShape2D


const DEFAULT_HURTBOX_COLOR: Color = Color("d100001a")


var _root: Node = null


func _enter_tree() -> void:
	_root = get_parent()
	
	if _root is Hurtbox2D:
		debug_color = DEFAULT_HURTBOX_COLOR


func _process(delta: float) -> void:
	if _root != null:
		if _root is Node2D:
			self.visible = _root.visible

	disabled = !visible

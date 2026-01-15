@tool
extends CollisionShape2D
class_name NotificationShape2D


const DEFAULT_HURTBOX_COLOR: Color = Color("d100001a")


func _enter_tree() -> void:
	if get_parent() is Hurtbox2D:
		debug_color = DEFAULT_HURTBOX_COLOR

@tool
extends CollisionShape2D
class_name NotificationShape2D


const DEFAULT_HURTBOX_COLOR: Color = Color("d100001a")
const DEFAULT_COLLISION_COLOR: Color = Color("00c2921e")


func _enter_tree() -> void:
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_PARENTED:
		_collider_changed_ev_handler()
	elif what == NOTIFICATION_VISIBILITY_CHANGED:
		_visibility_changed_ev_handler()
		
		

func _collider_changed_ev_handler() -> void:
	var parent = get_parent()
	if parent is Hurtbox2D:
		debug_color = DEFAULT_HURTBOX_COLOR
	elif parent is PhysicsUnit2D:
		debug_color = DEFAULT_COLLISION_COLOR


func _visibility_changed_ev_handler() -> void:
	disabled = !visible

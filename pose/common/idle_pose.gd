@tool
extends Pose2D


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		for node: Node in get_children():
			if node is Node2D:
				node.visible = visible


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	pass


func _exit() -> void:
	pass

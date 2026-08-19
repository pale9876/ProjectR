extends LimboState
class_name TFState


@export var root: Node2D


func _process(delta: float) -> void:
	pass


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			for node: Node in get_children():
				if node is Node2D:
					RenderingServer.canvas_item_set_parent(node.get_canvas_item(), get_canvas_item())
					node.global_position = root.global_position

		NOTIFICATION_PROCESS:
			for node: Node in get_children():
				if node is Node2D:
					node.global_position = root.global_position


func get_canvas_item() -> RID:
	return root.get_canvas_item()

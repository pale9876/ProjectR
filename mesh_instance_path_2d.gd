@tool
extends Path2D
class_name MeshInstancePath2D


func _init() -> void:
	if !curve:
		curve = Curve2D.new()
	curve.changed.connect(_on_curve_changed)


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_on_curve_changed()


func _on_curve_changed() -> void:
	for node: Node in get_children():
		if node is AlignedMultiMeshInstance2D:
			node._update()

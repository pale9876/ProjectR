@tool
extends StaticBody2D


@export var width: float = 0.:
	set(value):
		width = maxf(0., value)
		if is_node_ready():
			set_keikai()
@export var height: float = 0.:
	set(value):
		height = maxf(0., value)
		if is_node_ready():
			set_keikai()


func _init() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)

	input_pickable = true


func set_keikai() -> void:
	var top_left: Vector2 = Vector2()
	var top_right: Vector2 = Vector2(width, 0.)
	var bottom_left: Vector2 = Vector2(0., height)
	var bottom_right: Vector2 = Vector2(width, height)
	
	
	var top := get_top()
	var left := get_left()
	var right := get_right()
	var bottom := get_bottom()
	
	top.a = top_left
	top.b = top_right
	
	left.a = top_left
	left.b = bottom_left
	
	right.a = top_right
	right.b = bottom_right
	
	bottom.a = bottom_left
	bottom.b = bottom_right


func close() -> void:
	for node: Node in get_children():
		if node is CollisionShape2D:
			node.disabled = true


func open_left() -> void:
	get_segment(^"Left").disabled = true


func open_right() -> void:
	get_segment(^"Right").disabled = true


func open_bottom() -> void:
	get_segment(^"Bottom").disabled = true


func get_keikai() -> Rect2:
	return Rect2(
		global_position,
		global_position + Vector2(width, height)
	)


func get_segment(node_path: NodePath) -> CollisionShape2D:
	return get_node(node_path) as CollisionShape2D


func get_top() -> SegmentShape2D:
	return get_segment(^"Top").shape as SegmentShape2D


func get_left() -> SegmentShape2D:
	return get_segment(^"Left").shape as SegmentShape2D


func get_right() -> SegmentShape2D:
	return get_segment(^"Right").shape as SegmentShape2D


func get_bottom() -> SegmentShape2D:
	return get_segment(^"Bottom").shape as SegmentShape2D

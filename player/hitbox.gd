# player/hitbox.gd
extends Area2D
class_name PlayerHitbox


# Import
const UnitHurtbox: Script = preload("uid://bupj3hlvtt67s")
const Player: Script = preload("uid://c2uxhumgng18h")


func _init() -> void:
	visible = false
	
	monitorable = false
	monitoring = true
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(2, true)


func _enter_tree() -> void:
	area_shape_entered.connect(_entered)


func _exit_tree() -> void:
	area_shape_entered.disconnect(_entered)


func _entered(_rid: RID, area: Area2D, _area_idx: int, local_idx: int) -> void:
	if area is UnitHurtbox:
		var _shape := get_child(local_idx) as HitboxShape
		var player := get_parent() as Player
		var hitbox_info: HitboxInformation = _shape.hitbox_info
		
		var hit_result: HitResult = HitResult.create(
			player, area.get_parent() as Unit, player.state.face
		)
		
		area.damaged(hitbox_info, hit_result)
		_shape.push_result(hit_result)

		print("Enemy Hit => damage: {%s}" % hitbox_info.damage)


func clear() -> void:
	for node: Node in get_children():
		if node is HitboxShape or node is HitShapePolygon:
			node.clear()
	hide()


func get_hitbox(node_path: NodePath) -> HitboxShape:
	return get_node(node_path) as HitboxShape


func get_hitshape_polygon(node_path: NodePath) -> HitShapePolygon:
	return get_node(node_path) as HitShapePolygon


func set_dynamic(node_path: NodePath, offset: Vector2, height: float, range: float, ratio: float) -> void:
	var hit_polygon: HitShapePolygon = get_hitshape_polygon(node_path)
	hit_polygon.offset = offset
	hit_polygon.height = height
	hit_polygon.hit_range = range
	hit_polygon.ratio = ratio


func set_radius(node_path: NodePath, rad: float) -> void:
	var hit_shape: HitboxShape = get_hitbox(node_path)
	(hit_shape.shape as CircleShape2D).set_radius(rad)

	

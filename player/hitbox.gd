# player/hitbox.gd
@icon("uid://3njfw3qgjcnf")
extends Area2D
class_name PlayerHitbox


# Import
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
	
	var player := get_player()
	
	player.state.face_changed.connect(_on_face_changed)


func _on_face_changed() -> void:
	var player := get_player()
	scale.x = player.get_face()


func _exit_tree() -> void:
	area_shape_entered.disconnect(_entered)



func _entered(_rid: RID, area: Area2D, area_idx: int, local_idx: int) -> void:
	if area is Hurtbox:
		if area.get_owner() == get_component().get_owner(): return
		
		var _shape := get_child(local_idx) as HitboxShape
		var hitbox_info: HitboxInformation = _shape.hitbox_info
		var unit := area.get_parent() as Unit
		var collider := unit.get_collider()
		
		if _shape.result.size() >= hitbox_info.max_available_unit_hit_count:
			return
		
		if !check_collide(collider): return
		
		var player := get_player()
		var hit_result: HitResult = HitResult.create(
			player, unit, player.get_face()
		)
		
		area.damaged(hitbox_info, hit_result)
		# EventHorizon.player_hit(hitbox_info)
		_shape.push_result(hit_result)


func check_collide(to: Node2D) -> bool:
	var player := get_player()
	var param := PhysicsRayQueryParameters2D.create(
		player.get_collider().global_position, to.global_position,
		3, [player.get_rid()]
	)
	param.collide_with_areas = true
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	if !result.is_empty():
		if result.has("collider"):
			var obj: Object = result["collider"]
			if obj is StaticBody2D:
				return false
	
	return true


func clear() -> void:
	for node: Node in get_children():
		if node is HitboxShape:
			node.clear()
	hide()


func set_dynamic(node_path: NodePath, offset: Vector2, height: float, range: float, ratio: float) -> void:
	var hit_polygon: HitPolygon = get_hitshape(node_path) as HitPolygon
	hit_polygon.offset = offset
	hit_polygon.height = height
	hit_polygon.hit_range = range
	hit_polygon.ratio = ratio


func set_radius(node_path: NodePath, rad: float) -> void:
	var hit_shape: HitboxShape = get_hitshape(node_path)
	(hit_shape.shape as CircleShape2D).set_radius(rad)


func is_hit(node_path: NodePath) -> bool:
	return !(get_node(node_path) as HitboxShape).result.is_empty()


func get_hitshape(node_path: NodePath) -> HitboxShape:
	return get_node(node_path) as HitboxShape


func get_player() -> Player:
	return get_component().get_parent() as Player


func get_component() -> HitboxComponent:
	return get_parent() as HitboxComponent

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
		if node is HitboxShape:
			node.clear()
	hide()

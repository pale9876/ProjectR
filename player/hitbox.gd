# player/hitbox.gd
extends Area2D


# Import
const UnitHurtbox: Script = preload("uid://bupj3hlvtt67s")
const Unit: Script = preload("uid://bl84ixx4kubfe")


func _init() -> void:
	visible = false


func _enter_tree() -> void:
	area_shape_entered.connect(_entered)


func _entered(
	rid: RID,
	area: Area2D,
	area_idx: int,
	local_idx: int
) -> void:
	if area is UnitHurtbox:
		var hit_result: HitResult = HitResult.new()
		var hit_info: HitboxInformation = (get_child(local_idx) as HitboxShape).hitbox_info
		
		hit_result.damage = hit_info.damage
		hit_result.from = self
		hit_result.to = area.get_parent() as Unit
	
		area.damaged(hit_info.damage)
		
		print("Enemy Hit => damage: {%s}" % hit_info.damage)


func clear() -> void:
	for node: Node in get_children():
		if node is HitboxShape:
			node.hit_result = null

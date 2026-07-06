extends Area2D
class_name PlayerProjectiledHitbox


const UnitHurtbox: Script = preload("uid://bupj3hlvtt67s")


@export var max_count: int = 3


var spelled_by: Node2D


var hit_count: Dictionary[Unit, Dictionary] = {
	# Unit , {
		#HitboxShape, # Count
	# }
}

var entered: Array[Unit]



func _enter_tree() -> void:
	area_shape_entered.connect(_entered)
	area_shape_exited.connect(_exited)


func _exit_tree() -> void:
	area_shape_entered.disconnect(_entered)
	area_shape_exited.disconnect(_exited)


func _entered(_rid: RID, area: Area2D, shape_idx: int, local_idx: int) -> void:
	if area is UnitHurtbox:
		var unit := area.get_parent() as Unit
		if entered.size() < max_count and !entered.has(unit):
			entered.push_back(unit)
		
	

func _exited(_rid: RID, area: Area2D, shape_idx: int, local_idx: int) -> void:
	if area is UnitHurtbox:
		var unit := area.get_parent() as Unit
		if entered.has(unit):
			entered.erase(unit)


func emit_hit() -> void:
	await get_tree().physics_frame
	
	for unit: Unit in entered:
		if !hit_count.has(unit):
			pass
		#unit.get_hurtbox().damaged()


func clear() -> void:
	entered.clear()
	hit_count.clear()

func get_hitshape(node_path: NodePath) -> HitboxShape:
	return get_node(node_path) as HitboxShape

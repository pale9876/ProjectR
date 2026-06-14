# player/hitbox.gd
extends Area2D


# Import
const Hurtbox: Script = preload("uid://bupj3hlvtt67s")
const HitResult: Script = preload("uid://cvc6ymt6vgyht")


func _init() -> void:
	pass


func _enter_tree() -> void:
	area_shape_entered.connect(_entered)


func _entered(
	rid: RID,
	area: Area2D,
	area_idx: int,
	local_idx: int
) -> void:
	if area is Hurtbox:
		#var hit_result: HitResult = HitResult.new()
		var hit_info: HitboxInformation = (get_child(local_idx) as HitboxShape).hitbox_info
		area.damaged(hit_info.damage)
		print("Enemy Hit => damage: {%s}" % hit_info.damage)

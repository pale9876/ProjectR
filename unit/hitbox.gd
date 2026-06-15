# unit/hitbox.gd
extends Area2D


const PlayerHurtbox = preload("uid://er84buu2gymf")


var result: Array[HitResult]



func _init() -> void:
	visible = false



func _enter_tree() -> void:
	area_shape_entered.connect(entered)


func entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area is PlayerHurtbox:
		var hit_result: HitResult = HitResult.new()
		hit_result


func _clear() -> void:
	pass

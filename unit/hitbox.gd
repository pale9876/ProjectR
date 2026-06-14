# unit/hitbox.gd
extends Area2D


const HitResult = preload("uid://cvc6ymt6vgyht")
const PlayerHurtbox = preload("uid://er84buu2gymf")


var result: Array[HitResult]


func _enter_tree() -> void:
	area_entered.connect(entered)


func entered(area: Area2D) -> void:
	if area is PlayerHurtbox:
		var hit_result: HitResult = HitResult.new()
		hit_result


func _clear() -> void:
	pass

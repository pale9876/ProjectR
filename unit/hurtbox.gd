# unit/hurtbox.gd
extends Area2D


const Unit: Script = preload("uid://bl84ixx4kubfe")


func damaged(hit_result: HitResult) -> void:
	var unit: Unit = get_parent() as Unit
	unit.stat.hp -= hit_result.damage

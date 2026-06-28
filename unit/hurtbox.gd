# unit/hurtbox.gd
extends Area2D


enum {
	IDLE,
	COUNTER,
	
}


signal dodged


func damaged(hit_result: HitResult) -> void:
	var unit: Unit = get_parent() as Unit
	unit.stat.hp -= hit_result.damage

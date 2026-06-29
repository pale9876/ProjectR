# unit/hurtbox.gd
extends Area2D


enum State {
	IDLE,
	COUNTER,
	BLOCK,
}


signal dodged()
signal counter()


var state: State = State.IDLE


func damaged(hit_result: HitResult) -> void:
	var unit: Unit = get_parent() as Unit
	unit.stat.hp -= hit_result.damage

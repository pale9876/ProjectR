# player/hurtbox.gd
extends Area2D
class_name PlayerHurtbox


const Player: Script = preload("uid://c2uxhumgng18h")


enum State
{
	IDLE,
	COUNTER,
	GUARD,
	DODGE,
}


@export var state: State = State.IDLE


func damaged(hit_result: HitResult) -> void:
	var parent: Player = get_parent() as Player
	parent.stat.hp -= hit_result.damage
	parent.damaged.emit()

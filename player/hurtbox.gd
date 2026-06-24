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

const IDLE := State.IDLE
const COUNTER := State.IDLE
const GUARD := State.GUARD
const DODGE := State.DODGE


signal counter()
signal dodge()


@export var state: State = IDLE
@export var invincible: bool = false


func damaged(hit_result: HitResult) -> void:
	var player: Player = get_parent() as Player
	
	match state:
		COUNTER:
			
			counter.emit()
			return
		GUARD:
			pass
		DODGE:
			pass
	
	player.stat.hp -= hit_result.damage
	player.damaged.emit()

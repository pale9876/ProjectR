# player/hurtbox.gd
extends Area2D


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
	var damage: int = hit_result.damage
	
	match state:
		COUNTER:
			counter.emit()
			return
		GUARD:
			damage = int(damage * .25)
		DODGE:
			dodge.emit()
			damage = 0
	
	player.stat.hp -= damage
	player.damaged.emit()

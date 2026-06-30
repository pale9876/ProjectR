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

var invincible_frame: int = 0:
	set(value):
		invincible_frame = maxi(0, value)

@export var is_invincible: bool:
	get:
		return invincible_frame > 0


func _init() -> void:
	state = IDLE


func _physics_process(delta: float) -> void:
	if invincible_frame > 0:
		invincible_frame -= 1


func damaged(hit_result: HitResult) -> void:
	var player: Player = get_parent() as Player
	var damage: int = hit_result.damage
	var hurtbox := player.get_hurtbox()
	
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
	

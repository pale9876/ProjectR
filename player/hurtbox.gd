# player/hurtbox.gd
extends Area2D


const Player: Script = preload("uid://c2uxhumgng18h")


var _invincible: Timer = Timer.new()


func damaged(value: int, _duration: float = 0., hit_result: Resource = null) -> void:
	var parent: Player = get_parent() as Player
	parent.stat.hp -= value
	parent.damaged.emit(value)

	if _duration > 0.:
		add_child(_invincible)
		_invincible.start(_duration)
		_invincible.timeout.connect(_invincible_timer_ended)
		monitorable = false


func _invincible_timer_ended() -> void:
	monitorable = true
	remove_child(_invincible)

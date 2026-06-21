# npc/awareness.gd
extends Area2D


const PathedUnit: Script = preload("uid://dqd845y1secly")
const Player: Script = preload("uid://c2uxhumgng18h")


func _enter_tree() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)


func _exit_tree() -> void:
	body_entered.disconnect(_entered)
	body_exited.disconnect(_exited)


func _entered(body: Node2D) -> void:
	if body is Player:
		var unit := (get_parent() as PathedUnit)
		var risk_factor := unit.bt.blackboard.get_var(&"risk_factor") as Array
		risk_factor.push_back(body)
		unit.bt.blackboard.set_var(&"risk_factor", risk_factor)


func _exited(body: Node2D) -> void:
	var unit := (get_parent() as PathedUnit)
	if unit.bt.blackboard.get_var(&"rist_factor") as Array:
		pass
	

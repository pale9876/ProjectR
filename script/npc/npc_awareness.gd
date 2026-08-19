# npc/awareness.gd
extends Area2D


const PathedUnit: Script = preload("uid://dqd845y1secly")
const Player: Script = preload("uid://c2uxhumgng18h")


signal hostile_found()
signal hostile_lost()



func _enter_tree() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)


func _exit_tree() -> void:
	body_entered.disconnect(_entered)
	body_exited.disconnect(_exited)


func _entered(body: Node2D) -> void:
	pass


func _exited(body: Node2D) -> void:
	pass
	

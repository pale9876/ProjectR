extends Area2D


const Player: Script = preload("uid://c2uxhumgng18h")


func _enter_tree() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)


func _entered(body: Node2D) -> void:
	if body is Player:
		(get_parent() as Unit).get_bb().set_var(&"target", body)


func _exited(body: Node2D) -> void:
	if body is Player:
		(get_parent() as Unit).get_bb().set_var(&"target", null)

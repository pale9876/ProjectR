# unit/state/idle.gd
extends UnitState


var move_state: LimboState


func _enter() -> void:
	var unit := agent as Unit
	unit.sprite_component.play(&"idle")


func _update(_delta: float) -> void:
	pass

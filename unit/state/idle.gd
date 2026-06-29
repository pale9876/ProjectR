# unit/state/idle.gd
extends UnitState


var move_state: LimboState


func _enter() -> void:
	var unit := agent as Unit
	unit.sprite_component.play(&"idle")


func _update(_delta: float) -> void:
	var unit := agent as Unit
	var target := unit.get_bb().get_var(&"target") as Node2D;
	if target != null:
		pass

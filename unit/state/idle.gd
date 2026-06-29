# unit/state/idle.gd
extends UnitState


var move_state: LimboState


func _enter() -> void:
	var unit := agent as Unit
	unit.sprite_component.play(&"idle")


func _update(_delta: float) -> void:
	var unit := _get_unit()
	
	unit.velocity.x = move_toward(unit.velocity.x, 0., 15.5)
	
	move_and_slide()

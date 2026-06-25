extends UnitState


@export var move_state: LimboState
@export var anim: AnimationPlayer


func _enter() -> void:
	anim.play(&"idle")


func _update(_delta: float) -> void:
	var unit := agent as Unit
	var target := unit.get_bb().get_var(&"target") as Node2D;
	if target != null:
		pass

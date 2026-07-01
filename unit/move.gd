# unit/move.gd
extends UnitState


var idle_state: UnitState


func _enter_tree() -> void:
	add_library()


func _ready() -> void:
	idle_state = get_state(^"Idle")


func _enter() -> void:
	var unit := _get_unit()
	unit.sprite_component.play(&"move")


func _update(_delta: float) -> void:
	var unit := _get_unit()
	var target := get_bb_var(&"target") as Node2D;
	
	var target_direction := get_bb_var(&"target_direction") as float
	
	var motion: float = target_direction * unit.stat.speed
	unit.velocity.x = motion
	move_and_slide()


func _exit() -> void:
	pass

# unit/move.gd
extends UnitState


var idle_state: UnitState


#func _target_found() -> void:
	#pass
#
#
#func _target_lost() -> void:
	#pass



func _enter_tree() -> void:
	#add_library()
	pass


func _ready() -> void:
	idle_state = get_state(^"Idle")
	
	var unit := get_state_machine().get_parent() as Unit
	var awareness := unit.get_awareness_area()
	
	#awareness.found.connect(_target_found)
	#awareness.lost.connect(_target_lost)


func _enter() -> void:
	var unit := get_unit()
	play(&"move")


func _update(_delta: float) -> void:
	var unit := get_unit()
	var target := get_bb_var(&"target") as Node2D;
	
	var target_direction := get_bb_var(&"target_direction") as float
	
	var motion: float = target_direction * unit.stat.speed
	unit.velocity.x = motion
	move_and_slide()


func _exit() -> void:
	pass

# unit/state_machine.gd
extends LimboHSM


func get_anim() -> AnimationPlayer:
	return (get_parent() as Unit).get_anim()


func get_state(node_path: NodePath) -> UnitState:
	return get_node(node_path) as UnitState


func get_unit() -> Unit:
	return get_parent() as Unit

extends UnitState



func change_hurt(node_path: NodePath) -> void:
	get_hsm().get_node(node_path)


func get_hsm() -> LimboHSM:
	return get_parent().get_state_machine()

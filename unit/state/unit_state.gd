extends LimboState
class_name UnitState


func _get_unit() -> Unit:
	return agent as Unit


func _get_target() -> Node2D:
	return _get_unit().get_btbb().get_var(&"target") as Node2D

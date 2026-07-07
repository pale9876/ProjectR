@tool
extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	if object is PlayerState or object is UnitState:
		return true
	return false


func _parse_property(
	object: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	if hint_type == PROPERTY_HINT_RESOURCE_TYPE and name == "guard":
		#add_property_editor()
		return true
	return false

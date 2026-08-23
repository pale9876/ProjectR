# stat_attr_container.gd
extends HBoxContainer


# Import
const VariableStatisticsProgress = preload("uid://dvcrrp6wpmrtp")


@onready var stat_attr_name_container: VBoxContainer = %StatAttrNameContainer
@onready var stat_value_container: VBoxContainer = %StatValueContainer


func set_attr(attr_name: String, val: Variant) -> void:
	var label := Label.new()
	label.name = attr_name
	label.text = attr_name
	
	match typeof(val):
		TYPE_INT:
			var ui := VariableStatisticsProgress.new()
			ui.name = attr_name
			ui.value = val
			stat_attr_name_container.add_child(label)
			stat_value_container.add_child(ui)


func clear() -> void:
	for node: Node in stat_attr_name_container.get_children():
		node.queue_free()
	
	for node: Node in stat_value_container.get_children():
		node.queue_free()

@tool
extends EditorPlugin


const PropertyContainer: Script = preload("uid://b6h03yvmmqll3")
const ExpressionEditorInspectorPlugin: Script = preload("uid://bym1w6n766am8")


var plugin: ExpressionEditorInspectorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	plugin = ExpressionEditorInspectorPlugin.new()
	add_inspector_plugin(plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(plugin)

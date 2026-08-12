@tool
extends Button


# Import
const VariableStatisticsProgress: Script = preload("uid://dvcrrp6wpmrtp")

const PLACEHOLDER_EXECUTIONER: Texture = preload("uid://clcjxox00b83s")
const PLACEHOLDER_PREDATOR: Texture = preload("uid://cw7fw44ky8xln")
const PLACEHOLDER_TRICKSTER: Texture = preload("uid://clf6um28evr5d")



@export var class_info: ClassInfo


func _enter_tree() -> void:
	get_class_label().text = class_info.name
	get_icon().texture = class_info.icon


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	mouse_entered.connect(
		func() -> void:
			get_portrait().texture = class_info.portrait
			get_class_description().text = class_info.description
			for attr: String in class_info.stat:
				var progress: VariableStatisticsProgress = get_stat_attr_container().get_node_or_null(NodePath(attr))
				progress.value = class_info.stat[attr]
	)
	
	mouse_exited.connect(
		func() -> void:
			get_portrait().texture = null
			get_class_description().text = ""
			for attr: String in class_info.stat:
				var progress: VariableStatisticsProgress = get_stat_attr_container().get_node_or_null(NodePath(attr))
				progress.value = 0
	)
	
	button_up.connect(
		func () -> void:
			pass
	)


func get_class_label() -> Label:
	return get_node(^"%ClassLabel") as Label


func get_class_description() -> RichTextLabel:
	return get_node(^"%ClassDescription") as RichTextLabel


func get_portrait() -> TextureRect:
	return get_node(^"%ClassPortrait") as TextureRect


func get_icon() -> TextureRect:
	return get_node(^"%Icon") as TextureRect


func get_stat_attr_container() -> VBoxContainer:
	return get_node(^"%StatAttrContainer") as VBoxContainer


	

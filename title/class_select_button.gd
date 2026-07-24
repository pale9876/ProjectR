@tool
extends Button


const PLACEHOLDER_EXECUTIONER: Texture = preload("uid://clcjxox00b83s")
const PLACEHOLDER_PREDATOR: Texture = preload("uid://cw7fw44ky8xln")
const PLACEHOLDER_TRICKSTER: Texture = preload("uid://clf6um28evr5d")


@export var button_name: String:
	set(val):
		button_name = val
		if is_inside_tree():
			var label := get_class_label()
			if label != null:
				(label as Label).text = button_name

@export var class_icon: Texture2D:
	set(_tex):
		class_icon = _tex
		if is_inside_tree():
			var _con := get_icon()
			if _con != null:
				(_con as TextureRect).texture = class_icon
@export var portrait: Texture2D


func _init() -> void:
	portrait = PLACEHOLDER_TRICKSTER


func _enter_tree() -> void:
	get_class_label().text = button_name
	get_icon().texture = class_icon


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	mouse_entered.connect(
		func() -> void:
			get_portrait().texture = portrait
	)
	
	mouse_exited.connect(
		func() -> void:
			get_portrait().texture = null
	)


func get_class_label() -> Label:
	return get_node(^"%ClassLabel") as Label


func get_portrait() -> TextureRect:
	return get_node(^"%ClassPortrait") as TextureRect


func get_icon() -> TextureRect:
	return get_node(^"%Icon") as TextureRect


	

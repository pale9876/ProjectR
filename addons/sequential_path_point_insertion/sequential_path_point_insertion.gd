@tool
extends EditorPlugin


# Const (Image)
const ICON_KEY: Texture = preload("uid://c18huejpke7wf")


var insert_btn: Button


func _init() -> void:
	insert_btn = create_insert_key_btn()


func _enable_plugin() -> void:
	pass


func _disable_plugin() -> void:
	pass


func create_insert_key_btn() -> Button:
	var btn := Button.new()
	btn.text = "Insert Points"
	btn.icon = ICON_KEY
	return btn

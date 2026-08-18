#PDFormPage.gd
@tool
class_name PDFormPage extends ColorRect
## Creates a page in the document. Must be a child of [PDFormBase].
##
## All other elements ([PDFormLabel], [PDFormBox], and [PDFormImage]) must be a child of the
## page you want the element added to.[br]
## Elements are sorted back-to-front according to their order in the scene tree, so if you
## have a [PDFormBox] followed by a [PDFormLabel] and they occupy the same location on the
## document, the label will be drawn on top of the box -- as it normally is in Godot.[br]
## Changing the color of the page [b]will not[/b] change the color of the page saved in the
## document.


const _size : Vector2i = Vector2i(612,792)


@export var draw_center_line: bool = false:
	set(toggle):
		draw_center_line = toggle
		queue_redraw()



func _resize_default() -> void:
	self.set_position(Vector2i(0,0))
	self.custom_minimum_size = _size
	self.set_size(_size)
	self.rotation = 0



static func _get_any_class(node : Node) -> String:
	var out : String = ""
	var a = node.get_script()
	if !a == null:
		out = a.get_global_name()
	if a == null or out == "":
		out = node.get_class()
	return out



# Until I find a way to change the size of the document in PDF.gd, these will remain
# set forcefully to one size.
func _ready() -> void:
	_resize_default()
	set_notify_local_transform(true) # see _notification()



func _draw() -> void:
	if draw_center_line:
		pass



# This will resize and reposition the page if any transformation is performed.
func _notification(what : int) -> void:
	if what == NOTIFICATION_LOCAL_TRANSFORM_CHANGED:
		_resize_default()



func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray
	var parent = get_parent()
	if !parent is PDFormBase:
		warnings.append("May only be a child of PDFormBase.")
	var children = get_children()
	var permitted : Array[String] = ["PDFormLabel", "PDFormBox", "PDFormImage"]
	for c in children:
		if !_get_any_class(c) in permitted:
			warnings.append("Only children permitted: PDFormLabel, PDFormBox, and PDFormImage.")
			break
	return warnings

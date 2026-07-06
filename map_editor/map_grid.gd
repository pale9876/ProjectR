extends GridContainer


const MAPTILE: PackedScene = preload("uid://dyi2rrrxgabsy")


func _init() -> void:
	columns = 256


func get_editor_canvas() -> CanvasLayer:
	return get_parent() as CanvasLayer


func _ready() -> void:
	pass

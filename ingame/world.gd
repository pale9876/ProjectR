# world.gd
extends Node2D


@export var init_guidance: Array[MapGuidance]


var guidance: Dictionary[Rect2i, Map] = {}


func _enter_tree() -> void:
	pass


func add(_guide: MapGuidance) -> void:
	#assert(!has_overlapped(_guide.region), "해당 맵에 겹치는 부분이 존재합니다.")
	if has_overlapped(_guide.region):
		printerr("해당 맵이 다른 맵과 겹치는 영역이 존재합니다.")
		return
	
	var map := _guide.scene.instantiate() as Map
	guidance[_guide.region] = map
	add_child(map)


func erase(_loc: Vector2i) -> void:
	var map := get_map(_loc)
	guidance.erase(map.location)
	map.queue_free()


func has_overlapped(rect: Rect2i) -> bool:
	var ks: Array[Rect2i] = guidance.keys()
	for reg: Rect2i in ks:
		if rect.intersection(reg):
			return true
	
	return false


func get_map(_loc: Vector2i) -> Map:
	for rect: Rect2i in guidance.values():
		if rect.has_point(_loc):
			return guidance[rect]
	
	return null



	

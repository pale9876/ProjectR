# world.gd
@tool
extends Node2D


# Import
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const TILE_SIZE: int = 16


@export var tile_size: int = TILE_SIZE


var guidance: Dictionary[Rect2i, Map] = {
	
}
var current: Map = null


func get_current_map() -> Map:
	return current


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for node: Node in get_children():
		if (node is Map):
			if !guidance.values().has(node):
				var rect: Rect2i = node.get_region()
				guidance[rect] = node
			
			if current == null:
				change_map(node)
				print("Map Init")


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


func change_map(map: Map) -> void:
	current = map
	set_keikai(map)


func get_ingame() -> Ingame:
	return get_parent() as Ingame


func set_keikai(map: Map) -> void:
	var width: int = map.location.x + map.size.x
	var height: int = map.location.y + map.size.y
	
	var value := Vector4i(
		map.location.x * tile_size, # Left
		tile_size * width, # Right
		map.location.y * tile_size, # Ceil
		tile_size * height # Floor
	)
	
	var keikai := get_ingame().get_keikai()
	keikai.set_keikai(value)
	
	print(value)
	
	
	
	
	
	

# world.gd
@tool
extends Node2D


# Import
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const TILE_SIZE: int = 16


@export var tile_size: int = TILE_SIZE
@export var init_map: Map


var guidance: Dictionary[Rect2i, Map] = {
	
}


var current_map: Array[Map] = []


func append_map(map: Map) -> void:
	current_map.push_back(map)
	set_keikai()


func map_disable(map: Map) -> void:
	current_map.erase(map)


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for node: Node in get_children():
		if node is Map:
			if !guidance.values().has(node):
				var rect: Rect2i = node.get_region()
				guidance[rect] = node
	
	append_map(init_map)



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


func clear() -> void:
	current_map.clear()


func get_ingame() -> Ingame:
	return get_parent() as Ingame


func set_keikai() -> void:
	var locs: PackedVector2Array = PackedVector2Array()
	var dests: PackedVector2Array = PackedVector2Array()
	locs.resize(current_map.size())
	dests.resize(current_map.size())
	
	for i: int in range(current_map.size()):
		var _map: Map = current_map[i]
		locs[i] = Vector2(_map.location)
		dests[i] = Vector2(_map.location + _map.size)
	
	locs.sort()
	dests.sort()
	
	var min_point: Vector2 = locs[0]
	var max_point: Vector2 = dests[0]
	
	var _left: int = int(min_point.x * tile_size)
	var _right: int = int(max_point.x * tile_size)
	var _ceil: int = int(min_point.y * tile_size)
	var _floor: int = int(max_point.y * tile_size)
	
	var val: Vector4i = Vector4i(_left, _right, _ceil, _floor)
	get_ingame().get_keikai().set_keikai(val)
	
	
	
	
	

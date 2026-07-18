# map.gd
@tool
extends TileMapLayer
class_name Map


# Import
const World: Script = preload("uid://dpn1opeegcme2")


@export_group("Guidance")
@export var guidance: MapGuidance
@export var start_spawn_position: Marker2D
@export var stage: Stage


@export_group("Location")
@export var location: Vector2i:
	set(value):
		location = value.maxi(0)
		if get_world() != null:
			position = get_tile_size() * Vector2(location)
		queue_redraw()
@export var size: Vector2i = Vector2i.ONE:
	set(value):
		size = value.maxi(0)
		queue_redraw()
@export var floor_offset: float


@export_group("Attribute")
@export_subgroup("Floor")
@export var floor_breakable: bool = false
@export_subgroup("Wall")
@export_flags("Right", "Left") var wall_breakable: int:
	set(val):
		wall_breakable = val
		#print(val)
@export_flags("Right", "Left") var wall_opened: int:
	set(val):
		wall_opened = val
		print(val)


@export_group("DEBUG")
@export var debug_color: Color = Color(0.0, 1.0, 0.0, 0.157):
	set(val):
		debug_color = val
		queue_redraw()


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	if guidance:
		location = guidance.location
		size = guidance.size


func _draw() -> void:
	if Engine.is_editor_hint() and get_world() != null:
		draw_rect(Rect2(Vector2(), Vector2(size * get_tile_size())), debug_color)


func get_region() -> Rect2i:
	return Rect2i(location, size)


func add_unit(node: Node2D) -> void:
	stage.add_child(node)


func get_stage() -> Stage:
	return get_node(^"Stage") as Stage


func get_world() -> World:
	return get_parent() as World


func get_keikai():
	return get_world().get_parent()


func get_tile_size() -> float:
	return float(get_world().tile_size)
	

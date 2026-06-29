@tool
extends Area2D

# Import
const Player: Script = preload("uid://c2uxhumgng18h")


@export var offset: float = 128.:
	set(value):
		offset = value
		if polygon:
			set_polygon()
@export var height: float = 200.:
	set(value):
		height = maxf(0., value)
		if polygon:
			set_polygon()
@export var dist: float = 300.:
	set(value):
		dist = maxf(value, 0.)
		if polygon:
			set_polygon()
@export_range(0., 1., .01) var range_ratio: float = 1.:
	set(value):
		range_ratio = clampf(value, 0., 1.)
		if polygon:
			set_polygon()
@export var x_offset: float = - 10.:
	set(value):
		x_offset = value
		if polygon:
			set_polygon()


@onready var polygon: CollisionPolygon2D = $CollisionPolygon2D


func _init() -> void:
	monitorable = false
	monitoring = true
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(2, true)



func set_polygon() -> void:
	var result: PackedVector2Array = PackedVector2Array()
	var center_point: Vector2 = Vector2(x_offset, - offset)
	
	var top_left: Vector2 = center_point - Vector2(0., height / 2.)
	var bottom_left: Vector2 = center_point + Vector2(0., height / 2.)
	
	var top_right: Vector2 = Vector2(top_left.x + dist * range_ratio, top_left.y)
	var bottom_right: Vector2 = Vector2(bottom_left.x + dist * range_ratio, bottom_left.y)
	
	result.push_back(top_left)
	result.push_back(bottom_left)
	result.push_back(bottom_right)
	result.push_back(top_right)
	
	polygon.set_polygon(result)


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	body_entered.connect(_entered)
	body_exited.connect(_exited)


func _ready() -> void:
	set_polygon()


func _entered(body: Node2D) -> void:
	if body is Player:
		(get_parent() as Unit).get_btbb().set_var(&"target", body)


func _exited(body: Node2D) -> void:
	if body is Player:
		default()


func get_target() -> Node2D:
	return (get_parent() as Unit).get_btbb().get_var(&"target")


func set_target(node: Node2D) -> void:
	return (get_parent() as Unit).get_btbb().set_var(&"target", node)


func default() -> void:
	set_target(null)

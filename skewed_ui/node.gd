@tool
extends Node


var canvas_item: RID

@export var size: Vector2 = Vector2(20., 20.)
@export var position: Vector2 = Vector2(0., 0.):
	set(value):
		position = value
		RenderingServer.canvas_item_set_transform(canvas_item, Transform2D(0., position))
@export var skew: float = 10.
@export var color: Color = Color.WHITE
@export var outline_coor: Color
@export var outline_width: float = -1.

@export var margin: Vector2 = Vector2(5., 5.)


func _init() -> void:
	canvas_item = RenderingServer.canvas_item_create()


func free() -> void:
	RenderingServer.free_rid(canvas_item)


func _exit_tree() -> void:
	RenderingServer.canvas_item_clear(canvas_item)
	RenderingServer.canvas_item_set_parent(canvas_item, RID())


func _enter_tree() -> void:
	canvas_item = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(canvas_item, get_canvas())
	
	var polygon: PackedVector2Array = PackedVector2Array()
	var top_center: Vector2 = Vector2((Vector2.UP.rotated(deg_to_rad(skew)) * (size / 2.).length()).x, -size.y / 2.)
	var bottom_center: Vector2 = Vector2((Vector2.DOWN.rotated(deg_to_rad(skew)) * (size / 2.).length()).x, size.y / 2.)
	
	polygon.resize(4)
	polygon[0] = top_center - Vector2((size / 2.).x, 0.)
	polygon[1] = top_center + Vector2((size / 2.).x, 0.)
	polygon[2] = bottom_center + Vector2((size / 2.).x, 0.)
	polygon[3] = bottom_center - Vector2((size / 2.).x, 0.)
	
	
	RenderingServer.canvas_item_set_transform(canvas_item, Transform2D(0., position))
	RenderingServer.canvas_item_add_polygon(
		canvas_item,
		polygon, [color], EEAD.UV_DEFAULT_HORIZONTAL
	)

func get_canvas() -> RID:
	return (get_parent() as CanvasLayer).get_canvas()

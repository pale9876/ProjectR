extends GridContainer


const MAP_TILE_SCENE: PackedScene = preload("uid://dyi2rrrxgabsy")


var map_size: Vector2i = Vector2i(128, 128)


func _init() -> void:
	columns = 256


func get_editor_canvas() -> CanvasLayer:
	return get_parent() as CanvasLayer


func _ready() -> void:
	pass


func set_tile(sz: Vector2i) -> void:
	for y: int in range(sz.y):
		for x: int in range(sz.x):
			var tile := MAP_TILE_SCENE.instantiate() as MapTile
			add_child(tile)

	map_size = sz

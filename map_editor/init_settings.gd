# init_settings.gd
extends PanelContainer


# Import
const MapEditor: Script = preload("uid://dh7o2hk7gte68")



func get_map_size() -> Vector2i:
	var map_size_x := int((get_node("%MapSizeX") as SpinBox).value)
	var map_size_y := int((get_node("%MapSizeY") as SpinBox).value)
	
	return Vector2i(map_size_x, map_size_y)


func get_tile_size() -> Vector2i:
	#var tile_size_x := int((get_node("%TileSizeX") as SpinBox).value)
	#var tile_size_y := int((get_node("%TileSizeY") as SpinBox).value)
	#
	#return Vector2i(tile_size_x, tile_size_y)
	var tile_size: int = get_editor().get_grid().tile_size
	return Vector2i(tile_size, tile_size)


func get_submit() -> Button:
	return get_node(^"%Submit") as Button


func get_editor() -> MapEditor:
	return get_parent() as MapEditor

extends PanelContainer


func get_map_size() -> Vector2i:
	var map_size_x := int((get_node("%MapSizeX") as SpinBox).value)
	var map_size_y := int((get_node("%MapSizeY") as SpinBox).value)
	
	return Vector2i(map_size_x, map_size_y)


func get_tile_size() -> Vector2i:
	var tile_size_x := int((get_node("%TileSizeX") as SpinBox).value)
	var tile_size_y := int((get_node("%TileSizeY") as SpinBox).value)
	
	return Vector2i(tile_size_x, tile_size_y)


func get_submit() -> Button:
	return get_node(^"%Submit") as Button

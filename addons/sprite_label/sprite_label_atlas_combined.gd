@tool
@icon("icon_slc.png")
extends SpriteLabelAtlas
class_name SpriteLabelAtlasCombined

@export_category("Glyphs")
@export var glyph_sheet: Texture2D
@export var glyph_dimensions: Vector2i = Vector2i(8,8)
@export var glyph_padding: Vector2i = Vector2i(0,0)
@export var glyph_table: String = ""

@export_category("Control Characters")
@export var control_character_sheet: Texture2D
@export var control_character_dimensions: Vector2i = Vector2i(8,8)
@export var control_character_padding: Vector2i = Vector2i(0,0)
@export var control_character_table: Array[String] = []

func get_glyph(glyph: String) -> Texture2D:
	if glyph_sheet == null:
		push_warning("[SpriteLabel] Glyph sheet is null")
		return null
		
	var index: int = glyph_table.find(glyph)
	if index == -1 and single_case:
		var lower: String = glyph.to_lower()
		for i in glyph_table.length():
			if glyph_table[i].to_lower() == lower:
				index = i
				break
	
	if index == -1:
		push_warning("[SpriteLabel] No glyph found in atlas for '" + glyph + "'")
		return null
	
	return _get_texture_offset(glyph_sheet, glyph_dimensions, glyph_padding, index)
	
func get_control_character(control_character: String) -> Texture2D:
	if control_character_sheet == null:
		push_warning("[SpriteLabel] Control character sheet is null")
		return null

	var index := control_character_table.find(control_character)

	if index == -1:
		push_warning("[SpriteLabel] No control character found in atlas for '" + control_character + "'")
		return null

	return _get_texture_offset(
		control_character_sheet,
		control_character_dimensions,
		control_character_padding,
		index
	)

func _get_texture_offset(texture: Texture2D, dimensions: Vector2i, padding: Vector2i, offset: int) -> Texture2D:
	if texture == null:
		push_warning("[SpriteLabel] Texture for atlas is not set")
		return null
		
	if offset < 0:
		push_warning("[SpriteLabel] Offset must be >= 0")
		return null
		
	var texture_size: Vector2i = texture.get_size()
	var cell_width := dimensions.x + padding.x
	var cell_height := dimensions.y + padding.y
	
	if cell_width <= 0 or cell_height <= 0:
		push_warning("[SpriteLabel] Atlas dimensions/paddings are invalid")
		return null
	
	var columns := texture_size.x / cell_width
	var rows := texture_size.y / cell_height
	var max_index := columns * rows
	
	if offset >= max_index:
		push_warning("[SpriteLabel] Offset '" + str(offset) + "' does not exist in atlas")
		return null
	
	var x := offset % columns
	var y := offset / columns
	var region: Rect2i = Rect2i(
		x * cell_width,
		y * cell_height,
		dimensions.x,
		dimensions.y
	)
	
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = region
	return atlas

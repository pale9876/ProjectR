@tool
@icon("icon_sls.png")
extends SpriteLabelAtlas
class_name SpriteLabelAtlasSeperated

@export var glyphs: Dictionary[String, Texture2D]
@export var control_characters: Dictionary[String, Texture2D]

func get_glyph(glyph: String) -> Texture2D:
	for candidate_key in glyphs:
		if candidate_key == glyph:
			return glyphs[candidate_key]
		if single_case && candidate_key.to_lower() == glyph.to_lower():
			return glyphs[candidate_key]
	
	push_warning("[SpriteLabel] No glyph found in atlas for '" + glyph + "'")
	return null
	
func get_control_character(control_character: String) -> Texture2D:
	for candidate_key in control_characters:
		if candidate_key == control_character:
			return control_characters[candidate_key]
	
	push_warning("[SpriteLabel] No control character found in atlas for '" + control_character + "'")
	return null

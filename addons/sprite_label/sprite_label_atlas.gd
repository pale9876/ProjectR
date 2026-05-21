@tool
extends Resource
class_name SpriteLabelAtlas

@export var single_case: bool = true

func get_textures(input: String, use_control_characters: bool) -> Array[Texture2D]:
	var output: Array[Texture2D] = []
	var tokens: Array = split_text(input, use_control_characters)

	for token in tokens:
		match token.type:
			"glyph":
				var texture: = get_glyph(token.value)
				if texture:
					output.append(texture)
			"control":
				var texture: = get_control_character(token.value)
				if texture:
					output.append(texture)
	
	return output

func get_glyph(glyph: String) -> Texture2D:
	push_warning("[SpriteLabel] No glyph found in atlas for '" + glyph + "'")
	return null
	
func get_control_character(control_character: String) -> Texture2D:
	push_warning("[SpriteLabel] No control character found in atlas for '" + control_character + "'")
	return null
	
func split_text(input: String, use_control_characters: bool) -> Array:
	var tokens: Array = []
	var i := 0
	var length := input.length()

	while i < length:
		# Control character handling
		if use_control_characters and i + 1 < length and input.substr(i, 2) == "{{":
			var end := input.find("}}", i + 2)
			if end != -1:
				var control_name := input.substr(i + 2, end - (i + 2))
				tokens.append({
					"type": "control",
					"value": control_name
				})
				i = end + 2
				continue
			# Fall through if no closing braces found

		# Normal glyph (single Unicode character)
		var char := input[i]
		tokens.append({
			"type": "glyph",
			"value": char
		})
		i += 1

	return tokens

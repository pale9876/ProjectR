@tool
@icon("icon.png")
extends HBoxContainer
class_name SpriteLabel

@export var text: String = ""
@export var use_control_characters: bool = false
@export var spacing: int = 0
@export var atlas: SpriteLabelAtlas
		
@export_tool_button("Regenerate", "Callable") var regenerate_action = regenerate

func regenerate() -> void:
	if not atlas:
		push_error("[SpriteLabel] Couldn't render SpriteLabel: No atlas attached")
		return
		
	# Cleanup
	for child in get_children():
		child.queue_free()
		
	add_theme_constant_override("separation", spacing)
	
	var textures: Array[Texture2D] = atlas.get_textures(text, use_control_characters)
	for texture in textures:
		var texture_node = _get_texture_node(texture)
		add_child(texture_node)
		if Engine.is_editor_hint():
			texture_node.owner = get_tree().edited_scene_root
	
func _get_texture_node(texture: Texture2D) -> TextureRect:
	var texture_node: TextureRect = TextureRect.new()
	texture_node.texture = texture
	texture_node.stretch_mode = TextureRect.STRETCH_KEEP
	return texture_node

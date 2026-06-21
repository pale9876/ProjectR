extends RefCounted
class_name SpriteFrameMerger


static func merge(from: SpriteFrames, to: SpriteFrames) -> void:
	var anims: PackedStringArray = to.get_animation_names()
	
	for anim: StringName in anims:
		if anim in from.get_animation_names():
			from.clear(anim)
		
		from.add_animation(anim)
		from.set_animation_loop(anim, to.get_animation_loop(anim))
		from.set_animation_speed(anim, to.get_animation_speed(anim))
		for i: int in to.get_frame_count(anim):
			var frame_texture: Texture2D = to.get_frame_texture(anim, i)
			from.set_frame(anim, i, frame_texture, to.get_frame_duration(anim, i))

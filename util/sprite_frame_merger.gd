extends RefCounted
class_name AnimationMerger


static func sprite_frame_merge(
	from: SpriteFrames,
	to: SpriteFrames
) -> void:

	var anims: PackedStringArray = to.get_animation_names()
	
	for anim: StringName in anims:
		if anim in from.get_animation_names():
			from.clear(anim) # 이미 애니메이션이 존재해 있으면 지우고 새로 만들기
		
		from.add_animation(anim)
		from.set_animation_loop(anim, to.get_animation_loop(anim))
		from.set_animation_speed(anim, to.get_animation_speed(anim))
		for i: int in to.get_frame_count(anim):
			var frame_texture: Texture2D = to.get_frame_texture(anim, i)
			from.set_frame(anim, i, frame_texture, to.get_frame_duration(anim, i))


static func change_animation(
	anim: AnimationPlayer,
	lib_name: StringName,
	_animation: Animation,
	_name: StringName,
	_prefix: StringName = &""
) -> void:
	
	var library: AnimationLibrary = AnimationLibrary.new()
	if !anim.has_animation_library(lib_name):
		anim.add_animation_library(lib_name, library)
	else:
		library = anim.get_animation_library(lib_name)
	var fix : StringName = _prefix + (&"_" if !_prefix.is_empty() else &"")
	var _anim_name: StringName = fix + _name
	var err: Error = library.add_animation(_anim_name, _animation)
	if err != OK:
		printerr(
			"%s, AnimationMerger :: %s 애니메이션 추가 실패" % [
				err, _anim_name
			]
		)
	
	
	
	
	
	
	
	
	

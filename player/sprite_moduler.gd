# sprite_moduler.gd
@tool
extends Node2D


@export var upper: AnimatedSprite2D
@export var lower: AnimatedSprite2D


@export var animation: StringName = &"move"


@export_tool_button("Play", "AnimatedSprite2D") var _play: Callable = play.bind(animation)
@export_tool_button("Stop", "AnimatedSprite2D") var _stop: Callable = stop


var _reserve: Dictionary[NodePath, StringName] = {}
var _motion_finished: Dictionary[NodePath, Dictionary] = {}

@export_tool_button("Test Upper Animtion", "CharacterBody2D") var sub_anim_test: Callable = play_part.bind(^"Upper", "reload")


func _process(_delta: float) -> void:
	if !_reserve.is_empty():
		for path: NodePath in _reserve:
			var _sprite := get_node(path) as AnimatedSprite2D
			_motion_finished[path] = {"pre_anim": _sprite.animation ,"finished" : false}
			_sprite.play(_reserve[path])
			_sprite.animation_finished.connect(
				(func() -> void: _motion_finished[path]["finished"] = true),
				CONNECT_ONE_SHOT
			)
		_reserve.clear()
	
	if !_motion_finished.is_empty():
		for path: NodePath in _motion_finished:
			if _motion_finished[path]["finished"] == true:
				var _sprite := get_node(path) as AnimatedSprite2D
				_sprite.play(_motion_finished[path]["pre_anim"])
				_motion_finished.erase(path)



func play_part(node_path: NodePath, anim_name: StringName) -> void:
	_reserve[node_path] = anim_name



func play(anim_name: StringName) -> void:
	upper.play(anim_name)
	lower.play(anim_name)


func stop() -> void:
	upper.stop()
	lower.stop()

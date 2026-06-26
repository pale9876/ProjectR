# sprite_moduler.gd
@tool
extends Node2D


@export var upper: AnimatedSprite2D
@export var lower: AnimatedSprite2D


@export var animation: StringName = &"move"


@export_tool_button("Play", "AnimatedSprite2D") var _play: Callable = play.bind(animation)
@export_tool_button("Stop", "AnimatedSprite2D") var _stop: Callable = stop
@export_tool_button("Flip", "AnimatedSprite2D") var _flip: Callable = func():
	upper.flip_h = !upper.flip_h
	lower.flip_h = !lower.flip_h


func flip(x: float) -> void:
	if x == 0.: return
	
	var flipped: bool = true if x < 0. else false
	
	upper.flip_h = flipped
	lower.flip_h = flipped


func play_upper_module(anim_name: StringName) -> void:
	upper.play(anim_name)


func play_lower_module(anim_name: StringName) -> void:
	lower.play(anim_name)



func play(anim_name: StringName) -> void:
	upper.play(anim_name)
	lower.play(anim_name)


func stop() -> void:
	upper.stop()
	lower.stop()

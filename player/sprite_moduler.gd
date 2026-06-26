# sprite_moduler.gd
@tool
extends Node2D


@export var upper: AnimatedSprite2D
@export var lower: AnimatedSprite2D


@export var animation: StringName = &"move"
@export var sub_anim: StringName = &""

@export_tool_button("Play", "AnimatedSprite2D") var _play: Callable = play.bind(animation)
@export_tool_button("Stop", "AnimatedSprite2D") var _stop: Callable = stop
@export_tool_button("Flip", "AnimatedSprite2D") var _flip: Callable = (
	func():
		upper.flip_h = !upper.flip_h
		lower.flip_h = !lower.flip_h
)


var reserve: bool = false
var motion_finished: bool = false

@export_tool_button("Test Sub Motion Anim", "CharacterBody2D") var sub_anim_test: Callable = play_sub_motion.bind("reload")

func flip(x: float) -> void:
	if x == 0.: return
	
	var flipped: bool = true if x < 0. else false
	
	upper.flip_h = flipped
	lower.flip_h = flipped


func _process(_delta: float) -> void:
	if reserve:
		upper.play(sub_anim)
		reserve = false
		upper.animation_finished.connect(
			func(): motion_finished = true, CONNECT_ONE_SHOT
		)
	
	if motion_finished:
		upper.play(animation)
		upper.frame = lower.frame
		motion_finished = false


func play_sub_motion(anim_name: StringName) -> void:
	sub_anim = anim_name
	reserve = true


func play_lower_module(anim_name: StringName) -> void:
	lower.play(anim_name)


func play(anim_name: StringName) -> void:
	upper.play(anim_name)
	lower.play(anim_name)


func stop() -> void:
	upper.stop()
	lower.stop()

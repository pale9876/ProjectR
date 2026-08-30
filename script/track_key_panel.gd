# track_key_panel.gd
@icon("res://icon/ui/components/icon-comp-key-ui.svg")
extends Control


const TimeLine: Script = preload("uid://vid40exokkq0")
const TrackKeyButton = preload("uid://t7pfrr7gggfn")


@onready var timeline: TimeLine = %Timeline


func insert_key(frame: int) -> void:
	var key_point: Vector2 = Vector2(timeline.frame_get_distance(frame), position.y + size.y - 16.)
	var key_btn := TrackKeyButton.new()
	key_btn.position = key_point
	add_child(key_btn)
	pass


func move_frame_point(point: int, to: int) -> void:
	pass


func get_key() -> void:
	pass

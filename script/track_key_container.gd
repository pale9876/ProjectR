# track_key_container.gd
extends VBoxContainer


# Import
const TrackKeyPanel: Script = preload("uid://br0o21e6ceori")

# PackedScene
const TRACK_KEY_PANEL_SCENE: PackedScene = preload("uid://c6apiqqsa270h")


func _ready() -> void:
	pass


func add_track(track_name: StringName) -> void:
	var track := TRACK_KEY_PANEL_SCENE.instantiate() as TrackKeyPanel
	track.set_track_label(track_name)
	add_child.call_deferred(track)


func track_insert_trigger(track_name: String, frame: int, method_name: StringName) -> void:
	var track := get_track_panel(track_name)
	

func track_insert_toggle() -> void:
	pass


func track_insert_float() -> void:
	pass


func track_insert_integer() -> void:
	pass


func get_track_panel(track_name: String) -> TrackKeyPanel:
	return get_node(NodePath(track_name)) as TrackKeyPanel



	

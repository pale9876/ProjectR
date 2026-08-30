# hitbox_tab.gd
extends TabBar


# Import
const HitboxShapeInfoTab: Script = preload("uid://578fqg0vrxft")
const TrackKeyContainer: Script = preload("uid://n6ri1pjxe2xq")


# PackedScene
const HITBOX_SHAPE_INFO_TAB = preload("uid://cpcr2pgxmsphj")


@onready var add_hitbox_btn: Button = $HitboxInfoTab/Enter/VBoxContainer2/AddHitbox
@onready var hitbox_info_tab: TabContainer = $HitboxInfoTab
#@onready var track_key_container: TrackKeyContainer = %TrackKeyContainer


func _ready() -> void:
	add_hitbox_btn.button_up.connect(
		func () -> void:
			var new_hitbox_shape_info_tab := HITBOX_SHAPE_INFO_TAB.instantiate() as HitboxShapeInfoTab
			hitbox_info_tab.add_child(new_hitbox_shape_info_tab)
			hitbox_info_tab.current_tab = hitbox_info_tab.get_child_count() - 1
	)

	

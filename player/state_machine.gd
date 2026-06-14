# state_machine.gd
extends LimboHSM


# Global States
const Idle: Script = preload("uid://c08p61o8pw6vo")
const Move: Script = preload("uid://c4q85mvv6k6wb")


@export var label: Label


func _ready() -> void:
	active_state_changed.connect(_on_active_state_changed)


func _on_active_state_changed(current: LimboState, prev: LimboState) -> void:
	label.text = current.name

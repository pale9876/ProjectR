extends CanvasLayer
class_name HUD


@onready var character_icon: CharacterProfile = %CharacterIcon
@onready var hp_progress: GradientProgress = %HpProgress


func _enter_tree() -> void:
	Global.hud = self


func create_pointer() -> void:
	var pointer: CanvasScreenPointer = CanvasScreenPointer.new()
	add_child(pointer)

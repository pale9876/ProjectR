@tool
extends PhysicsUnit2D
class_name Player


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	InputHandler.player = self

@tool
extends PhysicsUnit2D


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	InputHandler.player = self

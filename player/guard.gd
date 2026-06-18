# guard.gd
extends PlayerState


@onready var anim: AnimationPlayer = $AnimationPlayer


func _enter() -> void:
	anim.play(&"guard_on")


func _update(_delta: float) -> void:
	pass


func _exit() -> void:
	pass

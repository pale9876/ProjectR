extends PlayerState


@onready var anim: AnimationPlayer = $AnimationPlayer


func _enter() -> void:
	anim.play(&"slide")



func _update(delta: float) -> void:
	pass

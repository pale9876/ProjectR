extends PlayerState


var idle_state: PlayerState

@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	pass

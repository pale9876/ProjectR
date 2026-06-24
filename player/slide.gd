extends PlayerState



@export var idle_state: LimboState
@export var move_state: LimboState
@export_custom(PROPERTY_HINT_RANGE, "-100., 100., .1") var force_minmax: Vector2


@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var player := get_player()
	anim.animation_finished.connect(_animation_finished)


func _enter() -> void:
	anim.play(&"slide")


func _update(_delta: float) -> void:
	var player := get_player()
	player.velocity.x = move_toward(player.velocity.x, 0., 12.5)


func _animation_finished(anim_name: StringName) -> void:
	if is_active() and anim_name == &"slide":
		get_hsm().change_active_state(idle_state)

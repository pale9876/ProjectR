extends PlayerState


@export_custom(PROPERTY_HINT_RANGE, "-100., 100., .1") var force_minmax: Vector2

var idle_state: LimboState
var move_state: LimboState

@onready var anim: AnimationPlayer = $AnimationPlayer



func _guard() -> bool:
	if is_on_floor() and get_state_machine().get_active_state() == move_state:
		return true
	return false


func _enter_tree() -> void:
	init_action()


func _ready() -> void:
	anim.animation_finished.connect(_animation_finished)
	
	idle_state = get_state_machine().get_state(^"Idle")
	move_state = get_state_machine().get_state(^"Move")


func _enter() -> void:
	var player := get_player()
	player.velocity.x = player.get_face() * 455.
	anim.play(&"slide")


func _update(_delta: float) -> void:
	var player := get_player()
	player.velocity.x = move_toward(player.velocity.x, 0., 6.5)
	move_and_slide()


func _animation_finished(anim_name: StringName) -> void:
	if is_active() and anim_name == &"slide":
		get_hsm().change_active_state(idle_state)

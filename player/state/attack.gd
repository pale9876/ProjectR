extends PlayerState

# import

# transition
@export var idle_state: LimboState
@export var move_state: LimboState

# module
@export var anim: AnimationPlayer
@export var hitbox: Area2D


func _enter_tree() -> void:
	anim.animation_finished.connect(_finished)


func _enter() -> void:
	var unit: Player = agent as Player
	var _suffix: StringName = blackboard.get_var(&"anim_suffix", &"")
	
	unit.velocity = Vector2.ZERO
	
	unit.sprite.play(&"idle" + _suffix)
	hitbox.rotation = Vector2(unit.state.face).angle()
	anim.play(&"attack")


func _finished(anim_name: StringName) -> void:
	if anim_name == &"attack":
		var unit: Player = agent as Player
		if unit.input_state.direction != Vector2.ZERO:
			(get_root() as LimboHSM).change_active_state(move_state)
			return
		else:
			(get_root() as LimboHSM).change_active_state(idle_state)

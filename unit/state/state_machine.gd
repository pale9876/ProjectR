# unit/state_machine.gd
extends LimboHSM


var locked_frame: int = 0:
	set(value):
		locked_frame = maxi(value, 0)


func _ready() -> void:
	add_transition(ANYSTATE, get_state(^"Idle"), &"revert")


func _physics_process(delta: float) -> void:
	if locked_frame > 0:
		locked_frame -= 1


func init_hurt_state(info: HitboxInformation, hit_result: HitResult, init_state: NodePath) -> void:
	var unit := get_unit()
	var next_state := get_state(init_state)
	
	unit.velocity = Vector2(info.force.x * hit_result.attack_direction, info.force.y)
	set_lock_frame(info.damage_frame)
	change_active_state(next_state)


func revert() -> void:
	if (get_active_state() as UnitState).type != IDLE:
		pass
	dispatch(&"revert")


func unlocked() -> bool:
	return locked_frame == 0


func get_anim() -> AnimationPlayer:
	return (get_parent() as Unit).get_anim()


func get_state(node_path: NodePath) -> UnitState:
	return get_node(node_path) as UnitState


func get_unit() -> Unit:
	return get_parent() as Unit


func set_lock_frame(value: int) -> void:
	locked_frame = value


func init_lock() -> void:
	locked_frame = 0


func tick() -> void:
	locked_frame -= 1

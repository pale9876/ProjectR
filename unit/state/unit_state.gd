extends LimboState
class_name UnitState


enum Type {
	IDLE,
	JUMP,
	HURT,
}


const IDLE := Type.IDLE
const JUMP := Type.JUMP

@export var type: Type = IDLE

# Import
const StateMachine: Script = preload("uid://dcybwuwfqeqr3")


func _get_unit() -> Unit:
	return agent as Unit


func _get_hsm() -> LimboHSM:
	return get_root() as LimboHSM


func _get_target() -> Node2D:
	return _get_unit().get_btbb().get_var(&"target") as Node2D


func move_order_received() -> Array[Dictionary]:
	return _get_unit().get_btbb().get_var(&"target_position") as Array[Dictionary]


func is_on_floor() -> bool:
	return _get_unit().is_on_floor()


func move_and_slide() -> bool:
	return _get_unit().move_and_slide()


func move_and_collide(
	motion: Vector2, test: bool = false, margin: float = .08
	) -> KinematicCollision2D:
	
	return _get_unit().move_and_collide(motion, test, margin, false)


func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine


func get_state(node_path: NodePath) -> UnitState:
	return get_state_machine().get_state(node_path)


func get_bb_var(var_name: StringName) -> Variant:
	return get_bb().get_var(var_name)


func set_bb_var(var_name: StringName, value: Variant) -> void:
	get_bb().set_var(var_name, value)


func get_bb() -> Blackboard:
	return get_state_machine().get_unit().bt.blackboard


func get_sprite() -> AnimatedSprite2D:
	return get_state_machine().get_unit().get_sprite()

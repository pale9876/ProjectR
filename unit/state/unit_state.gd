extends LimboState
class_name UnitState


# Import
const StateMachine: Script = preload("uid://dcybwuwfqeqr3")


enum Type {
	IDLE,
	JUMP,
	HURT,
}


const IDLE := Type.IDLE
const JUMP := Type.JUMP


@export var type: Type = IDLE
@export var anim_lib_name: StringName
@export var anim_lib: AnimationLibrary


func get_unit() -> Unit:
	return agent as Unit


func get_hsm() -> LimboHSM:
	return get_root() as LimboHSM


func get_target() -> Node2D:
	return get_unit().get_btbb().get_var(&"target") as Node2D


func move_order_received() -> Array[Dictionary]:
	return get_unit().get_btbb().get_var(&"target_position") as Array[Dictionary]


func is_on_floor() -> bool:
	return get_unit().is_on_floor()


func move_and_slide() -> bool:
	return get_unit().move_and_slide()


func move_and_collide(
	motion: Vector2, test: bool = false, margin: float = .08
	) -> KinematicCollision2D:
	
	return get_unit().move_and_collide(motion, test, margin, false)


func get_state_machine() -> StateMachine:
	return get_parent() as StateMachine


func get_anim() -> AnimationPlayer:
	return get_state_machine().get_anim()


func play(anim_name: StringName) -> void:
	return get_anim().play(anim_lib_name + &"/" + anim_name)


# OVERRIDE
func event(ev: HitboxInformation) -> void:
	pass


# OVERRIDE
func set_data(info: Resource) -> void:
	pass

func take_force(motion: Vector2) -> void:
	var unit := get_unit()
	
	var shape_param := PhysicsShapeQueryParameters2D.new()
	shape_param.shape = (unit.get_node(^"UnitCollision") as CollisionShape2D).shape
	shape_param.transform = unit.get_global_transform()
	shape_param.motion = Vector2(motion.x * unit.input_state.direction.x, motion.y)
	shape_param.collision_mask = 1
	shape_param.exclude = [unit.get_rid()]
	
	var direct_state := unit.get_world_2d().direct_space_state
	var result := direct_state.cast_motion(shape_param)
	var unsafe_propotion: float = result[1]
	
	move_and_collide(unsafe_propotion * shape_param.motion)


func _propel(motion: Vector2) -> void:
	var unit := get_unit()
	unit.velocity = motion


func create_animlib() -> void:
	assert(anim_lib_name)
	get_anim().add_animation_library(anim_lib_name, AnimationLibrary.new())


func add_library() -> void:
	assert(anim_lib)
	assert(anim_lib_name)
	get_anim().add_animation_library(anim_lib_name, anim_lib)


func add_animation(anim_name: StringName, anim: Animation) -> void:
	assert(anim_lib)
	assert(anim_lib_name)
	var _lib := get_anim().get_animation_library(anim_lib_name)
	_lib.add_animation(anim_name, anim)


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


func set_suffix(value: StringName) -> void:
	set_bb_var(&"suffix", value)


func get_suffix() -> StringName:
	var result := get_bb_var(&"suffix") as StringName
	set_bb_var(&"suffix", &"")
	return result



	

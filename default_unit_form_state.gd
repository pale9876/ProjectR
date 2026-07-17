@abstract
extends LimboState
class_name DefaultUnitFormState


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


enum Type {
	IDLE,
	JUMP,
}


# const (Type)
const IDLE := Type.IDLE
const JUMP := Type.JUMP


@export_group("State Type")
@export var type: Type = IDLE


@export_group("Animations")
@export var anim_library: AnimationLibrary
@export var library_name: StringName


var motion: Vector2 = Vector2()
var force_duration: int = 0:
	set(value):
		force_duration = maxi(value, 0)
		if force_duration == 0:
			motion = Vector2()


var _substate: LimboSubState


func change_sub_state(sub_state: LimboSubState) -> void:
	_substate.exit()
	_substate = sub_state
	sub_state.enter()


# OVERRIDE
func _guard() -> bool:
	return true


# OVERRIDE
func _clear() -> void:
	pass


func get_sub_states() -> Array[LimboSubState]:
	var result: Array[LimboSubState] = []
	for node: Node in get_children():
		if node is LimboSubState:
			result.push_back(node)
	
	return result


func get_sub_state(node_path: NodePath) -> LimboSubState:
	return get_node(node_path) as LimboSubState


func get_state(node_path: NodePath) -> LimboState:
	return get_hsm().get_node(node_path) as LimboState


func get_hsm() -> LimboHSM:
	return get_parent() as LimboHSM


func get_replicator() -> Replicator:
	return get_hsm().get_parent() as Replicator


func get_hurtbox() -> Hurtbox:
	return get_replicator().get_hurtbox()


func get_anim() -> AnimationPlayer:
	return get_replicator().get_anim()


func get_player() -> Player:
	return get_replicator() as Player


func change_state(state: LimboState) -> void:
	get_hsm().change_active_state(state)

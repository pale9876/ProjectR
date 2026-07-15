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


var current: LimboSubState


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			var substates: Array[LimboSubState] = get_sub_states()
		
			if !substates.is_empty():
				current = get_sub_states()[0]


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


# OVERRIDE
func _guard() -> bool:
	return true


# OVERRIDE
func _clear() -> void:
	pass


func get_player() -> Player:
	return get_replicator() as Player


#func get_unit() -> Unit:
	#return get_replicator() as Unit


#func _lock() -> void:
	#get_player().input_state.lock()
#
#
#func _unlock() -> void:
	#get_player().input_state.unlock()


func change_state(state: LimboState) -> void:
	get_hsm().change_active_state(state)

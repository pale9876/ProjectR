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


func get_hsm() -> LimboHSM:
	return get_parent() as LimboHSM

#
#func get_anim() -> AnimationPlayer:
	#return get_hsm().get_parent().get_node(^"AnimationPlayer")
#



	

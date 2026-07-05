extends LimboState
class_name HurtState


const Player: Script = preload("uid://c2uxhumgng18h")


func get_gravity(delta: float) -> void:
	pass


func change_hurt(node_path: NodePath) -> void:
	get_hsm().get_node(node_path)


func get_hsm() -> LimboHSM:
	return get_parent().get_state_machine()


func get_unit() -> CharacterBody2D:
	return agent as CharacterBody2D

	

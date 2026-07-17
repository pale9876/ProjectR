@icon("uid://bav6hfipt5tol")
extends Node
class_name LimboSubState


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


func _init() -> void:
	set_process(false)
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if is_active():
		pass

# OVERRIDE:
func enter() -> void:
	pass


func update(delta: float) -> void:
	pass



func get_anim() -> AnimationPlayer:
	return get_state().get_anim()


func play(anim_name: StringName) -> void:
	get_state().get_anim().play(anim_name)


func is_active() -> bool:
	return get_state().current == self and get_state().is_active()


func get_state() -> DefaultUnitFormState:
	return get_parent() as DefaultUnitFormState


func get_body() -> CharacterBody2D:
	return get_state_machine().get_parent() as CharacterBody2D


func get_state_machine() -> LimboHSM:
	return get_state().get_parent() as LimboHSM


func get_unit() -> Unit:
	return get_state().agent as Unit


func get_player() -> Player:
	return get_state().agent as Player





	

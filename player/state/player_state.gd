extends LimboState
class_name PlayerState


const Player: Script = preload("uid://c2uxhumgng18h")
const StateMachine: Script = preload("uid://nmmtety5yvve")


func get_hsm() -> LimboHSM:
	return get_root() as LimboHSM


func get_player() -> Player:
	return agent as Player


func is_on_floor() -> bool:
	return get_player().is_on_floor()


func move_and_slide() -> bool:
	return get_player().move_and_slide()

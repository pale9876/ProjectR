@tool
extends Pose2D



func _enter() -> void:
	if agent is PhysicsUnit2D:
		agent.velocity -= get_agent_information().jump_force


func _update(_delta: float) -> void:
	pass


func _fixed_update(_delta: float) -> void:
	pass

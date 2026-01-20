@tool
extends Pose2D


@export var idle_pose: Pose2D


func _update(_delta: float) -> void:
	if agent is PhysicsUnit2D:
		if agent._on_floor:
			get_controller().change_pose(idle_pose)

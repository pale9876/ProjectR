@tool
extends Pose2D


@export var move_pose: Pose2D
@export var fall_pose: Pose2D


func _update(_delta: float) -> void:
	var input_dir: Vector2 = Vector2.ZERO

	if agent == InputHandler.player:
		input_dir = InputHandler.get_input_dir()
	
	if agent is PhysicsUnit2D:
		var current_speed: float = agent.velocity.x
		if current_speed != 0.:
			agent.velocity.x = move_toward (
				current_speed, 0., _delta * agent.get_information().friction
			)

		if agent._on_floor:
			get_controller().change_pose(fall_pose)
	
	if input_dir.x != 0.:
		get_controller().change_pose(move_pose)
	

func _exit() -> void:
	pass

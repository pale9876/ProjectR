@tool
extends Pose2D


@export var idle_pose: Pose2D


func _update(_delta: float) -> void:
	if agent is PhysicsUnit2D:
		if agent._on_floor:
			get_controller().change_pose(idle_pose)

	var input_dir: Vector2 = Vector2.ZERO
	if agent == InputHandler.player:
		input_dir = InputHandler.get_input_dir()
		
	var unit_move_speed: float = agent.get_information().speed * input_dir.x
	var current_speed: float = agent.velocity.x
		
	agent.velocity.x = move_toward(
		current_speed, unit_move_speed, _delta * agent.get_information().acceleration
	)

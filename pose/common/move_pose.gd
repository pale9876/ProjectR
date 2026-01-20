@tool
extends Pose2D


@export var idle_pose: Pose2D
@export var fall_pose: Pose2D


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	var input_dir: Vector2 = Vector2.ZERO
	
	if agent == InputHandler.player:
		input_dir = InputHandler.get_input_dir()
	
	if agent is PhysicsUnit2D:
		var unit_speed: float = agent.get_information().speed * input_dir.x
		var current_speed: float = agent.velocity.x
		agent.velocity.x = move_toward(
			current_speed, unit_speed, _delta * agent.get_information().acceleration
		)

	if input_dir == Vector2.ZERO:
		get_controller().change_pose(idle_pose)
	

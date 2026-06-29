extends PlayerState



enum MotionState
{
	NONE,
	KNOCKBACK,
	AERIAL,
	DOWN,
}


var _state: MotionState = MotionState.NONE


func _enter() -> void:
	pass

extends UnitState


enum MotionState {
	NONE,
	KNOCKBACK,
	AERIAL,
	PUSHBACK,
}


const NONE := MotionState.NONE
const KNOCKBACK := MotionState.KNOCKBACK
const AERIAL := MotionState.AERIAL
const PUSHBACK := MotionState.PUSHBACK


var idle_state: LimboState


var damage_frame: int = 0


@onready var anim: AnimationPlayer = $AnimationPlayer


var _state: MotionState = MotionState.NONE
var _motion: Vector2 = Vector2()


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")


func _update(_delta: float) -> void:
	var unit := _get_unit()
	
	match _state:
		KNOCKBACK:
			unit.velocity.x = move_toward(_motion.x, 0., 7.25)
			var collide: KinematicCollision2D = move_and_collide(unit.velocity)
		AERIAL:
			pass
	
	
	
	
	

	damage_frame -= 1
	


func _exit() -> void:
	pass

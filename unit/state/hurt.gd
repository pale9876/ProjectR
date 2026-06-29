extends UnitState


# Import
const HurtEv: Script = preload("uid://cpbogpcwj4utb")



var idle_state: LimboState


var damage_frame: int = 0:
	set(value):
		damage_frame = maxi(value, 0)


@onready var anim: AnimationPlayer = $AnimationPlayer


var _state := HurtEv.NONE
var _motion: Vector2 = Vector2()


func _ready() -> void:
	idle_state = get_state_machine().get_state(^"Idle")


func _update(_delta: float) -> void:
	var unit := _get_unit()
	
	match _state:
		HurtEv.KNOCKBACK:
			_motion.x = move_toward(_motion.x, 0., 7.25)
			unit.velocity = _motion
			move_and_slide()

		HurtEv.AERIAL:
			pass

	if damage_frame == 0:
		pass
	else:
		damage_frame -= 1
	


func _exit() -> void:
	damage_frame = 0

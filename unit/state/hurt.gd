# unit/state/hurt.gd
extends UnitState



const NONE := HurtEV.MotionState.NONE
const KNOCKBACK := HurtEV.MotionState.KNOCKBACK
const AERIAL := HurtEV.MotionState.AERIAL
const PUSHBACK := HurtEV.MotionState.PUSHBACK
const DOWNED := HurtEV.MotionState.DOWNED


var idle_state: LimboState


var damage_frame: int = 0:
	set(value):
		damage_frame = maxi(value, 0)


@onready var anim: AnimationPlayer = $AnimationPlayer


var state: HurtEV.MotionState = NONE
var motion: Vector2 = Vector2()


func set_state(value: HitboxInformation.Type) -> void:
	var result: HurtEV.MotionState
	
	match value:
		HitboxInformation.Type.KNOCKBACK:
			if state in [PUSHBACK, AERIAL]:
				result = AERIAL
			elif state == DOWNED:
				result = DOWNED
			else:
				result = KNOCKBACK
		HitboxInformation.Type.AERIAL:
			result = AERIAL

	state = result


func _ready() -> void:
	var state_machine := get_state_machine()
	
	idle_state = state_machine.get_state(^"Idle")


func _enter() -> void:
	assert(state != NONE)
	var unit := _get_unit()
	
	match state:
		KNOCKBACK:
			unit.sprite_component.play(&"knockback")
		AERIAL:
			unit.sprite_component.play(&"aerial")


func _update(_delta: float) -> void:
	var unit := _get_unit()
	
	match state:
		KNOCKBACK:
			motion.x = move_toward(motion.x, 0., 7.25)
			unit.velocity = motion
			move_and_slide()

		AERIAL:
			unit.velocity = motion
			
			move_and_slide()
			
			if !is_on_floor():
				motion.y = move_toward(motion.y, 970., 23.25)
			else:
				unit.sprite_component.play(&"down")
				state = DOWNED


	if damage_frame == 0:
		if state == AERIAL:
			return
		
		if state == DOWNED:
			state = NONE
			anim.play(&"standup")
		else:
			_get_hsm().change_active_state(idle_state)
	else:
		damage_frame -= 1
	


func _exit() -> void:
	state = NONE
	damage_frame = 0


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"standup":
		var unit := _get_unit()
		unit.get_hurtbox().invincible_frame = 10
		_get_hsm().change_active_state(idle_state)

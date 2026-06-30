# unit/state/hurt.gd
extends UnitState



const NONE := HurtEV.MotionState.NONE
const KNOCKBACK := HurtEV.MotionState.KNOCKBACK
const AERIAL := HurtEV.MotionState.AERIAL
const PUSHBACK := HurtEV.MotionState.PUSHBACK
const DOWNED := HurtEV.MotionState.DOWNED
const DOWN_ATTACKED := HurtEV.MotionState.DOWN_ATTACKED


var idle_state: LimboState


var damage_frame: int = 0:
	set(value):
		damage_frame = maxi(value, 0)



var state: HurtEV.MotionState = NONE
var prev_state := NONE
var reserve:= NONE

var motion: Vector2 = Vector2()


func reserve_state(value: HitboxInformation.Type) -> void:
	var result: HurtEV.MotionState = NONE # ERROR
	
	match value:
		HitboxInformation.Type.KNOCKBACK:
			if state in [PUSHBACK, AERIAL]:
				result = AERIAL
			
			match state:
				DOWNED:
					result = DOWN_ATTACKED
				_:
					result = KNOCKBACK

		HitboxInformation.Type.AERIAL:
			result = AERIAL
		
		HitboxInformation.Type.BLOWUP:
			result = AERIAL
		
		HitboxInformation.Type.PUSHBACK:
			result = AERIAL

	if state != NONE:
		reserve = result
	else:
		state = result


func _ready() -> void:
	var state_machine := get_state_machine()
	
	idle_state = state_machine.get_state(^"Idle")
	#anim.animation_finished.connect(_on_animation_finished)


func _enter() -> void:
	if reserve != NONE:
		state = reserve
		reserve = NONE
	
	assert(state != NONE, "피격 상태가 정해지지 않았습니다.")

	var unit := _get_unit()
	
	match state:
		KNOCKBACK:
			#unit.sprite_component.play(&"knockback")
			pass
		AERIAL:
			#unit.sprite_component.play(&"aerial")
			pass
		DOWN_ATTACKED:
			#anim.play(&"down_attacked")
			pass


func _update(_delta: float) -> void:
	var unit := _get_unit()
	
	match state:
		KNOCKBACK:
			motion.x = move_toward(motion.x, 0., 7.25)

		AERIAL:
			if is_on_floor():
				unit.sprite_component.play(&"down")
				unit.velocity.y = 0.
				state = DOWNED

		DOWNED:
			motion.x = move_toward(motion.x, 0., 7.25)

		DOWN_ATTACKED:
			motion.x = move_toward(motion.x, 0., 12.25)

	unit.velocity = motion
	move_and_slide()
	
	if !is_on_floor():
		motion.y = move_toward(motion.y, 970., 23.25)

	if damage_frame == 0:
		if state in [AERIAL, PUSHBACK, DOWN_ATTACKED]:
			return
		elif state == DOWNED:
			state = NONE
			#anim.play(&"standup")
			unit.get_hurtbox().is_invincible = true
			return
		elif state == DOWN_ATTACKED:
			pass
		elif state == KNOCKBACK:
			_get_hsm().change_active_state(idle_state)

	else:
		damage_frame -= 1


func _exit() -> void:
	prev_state = state
	state = NONE
	damage_frame = 0


func _on_animation_finished(anim_name: StringName) -> void:
	var unit := _get_unit()
	var hsm := _get_hsm()
	
	match anim_name:
		&"standup":
			hsm.change_active_state(idle_state)
			unit.get_hurtbox().is_invincible = false
		&"down_attacked":
			unit.sprite_component.play(&"down")
			state = DOWNED

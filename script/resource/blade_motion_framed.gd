# blade_motion_frame.gd
@tool
extends Resource
class_name BladeMotionFrame


const TICK: float = 1. / 60.


@export var name: String = "Idle"
@export var motive: Animation
@export var frame_length: int = 16
@export var hit_hold_frame: int = 2
@export var follow_up_command: Array[String] # 후속 커맨드
@export var trigger: Array[BladeMotionTrigger]


func parse() -> Animation:
	if !motive:
		motive = Animation.new()
	#var anim: Animation = Animation.new()
	#anim.length = motion.frame_length * TICK
	
	for trigger: BladeMotionTrigger in trigger:
		var _track: int = plant_trigger(motive, trigger)
	
	return motive


func plant_trigger(anim: Animation, trigger: BladeMotionTrigger) -> int:
	var _track: int = anim.add_track(Animation.TYPE_METHOD)
	anim.track_set_path(_track, trigger.target_path)
	anim.value_track_set_update_mode(_track, Animation.UPDATE_DISCRETE)
	anim.track_insert_key(_track, TICK * trigger.frame, trigger.get_dict())
	
	return _track

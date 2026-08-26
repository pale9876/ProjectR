extends Resource
class_name BladeModuleInfo


enum RangeType {
	CLOSE,
	LONG,
	
}

@export var attack_range: RangeType = RangeType.CLOSE
@export_flags(
	"PREDATOR",
	"EXECUTIONER",
	'CHIMERA',
	'TRICKSTER',
	"PUPPETEER",
	"EXORCIST"
) var band: int = 0 # 0 == ANY
@export var name: StringName = ""
@export var activate_by_weapon_only: bool = false
@export var input_command: Array[String]
@export var can_follow_up: bool = true
@export var follow_up_command: Array[String]


@export_group("Scene")
@export var sprite_motion: PackedScene
@export var target_state: PackedScene
@export var substate: Array[PackedScene]
@export var hitbox: PackedScene
@export var library_name: StringName
@export var motion_info: Array[BladeMotionFramed] = []


@export_group("Stat")

#@export var when_stand: BladeModuleStat
#@export var when_exposed: BladeModuleStat
#@export var when_downed: BladeModuleStat


static func _create_motion(motion: BladeMotionFramed) -> Animation:
	var anim: Animation = Animation.new()
	anim.length = motion.frame_length
	
	var motion_track: int = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(motion_track, ^"SpriteComponent")
	anim.track_insert_key(motion_track, BladeMotionFramed.TICK, motion.name)
	# TODO
	
	var hitbox_track: int = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(hitbox_track, NodePath("HitboxComponent/" + motion.name))
	# TODO
	#anim.track_insert_key()
	
	return anim


func init_module(unit: Unit) -> void:
	var motion_lib: MotionLibrary = unit.get_anim()
	var hitbox_component: HitboxComponent = unit.get_hitbox_component()
	var hsm: StateMachine = unit.get_state_machine()
	
	# Init State / SubStates
	var state := target_state.instantiate() as DefaultUnitFormState
	if !hsm.has_state(String(state.name)):
		hsm.add_child(state)
	
	for _scene: PackedScene in substate:
		var _substate := _scene.instantiate() as LimboSubState
		if !state.has_substate(_substate.name):
			state.add_child(_substate)
	
	# Init Motion
	var anim_lib: AnimationLibrary = AnimationLibrary.new()
	
	for motion: BladeMotionFramed in motion_info:
		var anim: Animation = _create_motion(motion)
		anim_lib.add_animation(motion.name, anim)
	
	motion_lib.add_animation_library(library_name, anim_lib)

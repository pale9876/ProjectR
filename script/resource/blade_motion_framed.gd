extends Resource
class_name BladeMotionFramed


const TICK: float = 1. / 60.

@export var name: String = "Idle"
@export var frame_length: int = 16
@export var hit_hold_frame: int = 2
@export var trigger: Dictionary[NodePath, Dictionary]
# { #NodePath, {
#			frame(int) : method(StringName)
#		}
#}

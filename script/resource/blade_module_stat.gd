extends Resource
class_name BladeModuleStat





@export_range(0., 1., .01) var damage_ratio: float = 1.
@export_enum(
	"Knockback",
	"Aerial",
	"DownHit",
) var after_state: String
@export var stun_frame: int = 10
@export var force: Vector2
@export var disturb_motion: bool = true # == 피격자의 모션 속도에 영향을 줍니다.

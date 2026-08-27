extends Resource
class_name BladeModuleStat


enum DamageType {
	NONE,
	HAMMER,
	EXPLOSIVE,
	SLASH,
}


@export var type: DamageType = DamageType
@export_range(0., 1., .01) var damage_ratio: float = 1.

@export_enum(
	"Knockback",
	"Aerial",
	"Pound",
) var aftermath: String = "Knockback"

@export var stun_frame: int = 10
@export var force: Vector2
@export var disturb_motion: bool = true # == 피격자의 모션 속도에 영향을 줍니다.

extends Resource
class_name HitboxInformation


enum Type {
	KNOCKBACK,
	AERIAL,
	PUSHBACK,
	BLOWUP,
	DOWN_ATTACK,
}

@export_group("Attack Stat")
@export var atk_name: StringName = &""
@export var type: Type = Type.KNOCKBACK
@export var damage: int = 10
@export var damage_frame: int = 9
@export var force: Vector2 = Vector2(200., 0.)
@export var stun_time: int = 8
@export var blockable: bool = true
@export var trace: bool = true
@export var max_available_unit_hit_count: int = 1


@export_group("Camera Effect Strength")
@export var shake_strength: float = 30. # 공격자 카메라 흔들림 강도
@export var reverse_shake_strength: float = 45. # 피격자 카메라 흔들림 강도


@export_group("When Blocked")
@export var block_reduction_frame: int = 3
@export_range(0., 1., .01) var blocked_reduction_force_ratio: float = .55


@export_group("When Downed")
@export var when_downed_will_received_atk_type: Type = Type.KNOCKBACK
@export_range(0., 1., .01) var downed_damage_reduction_ratio: float = .75
@export var additional_frame: int = 5
@export var downed_reduction_force_ratio: Vector2 = Vector2(.75, .5)

extends Resource
class_name DownAttackedEffect

@export var atk_type: HitboxInformation.Type = HitboxInformation.KNOCKBACK
@export_range(0., 1., .01) var reduction_ratio: float = .75
@export var additional_frame: int = 5
@export var downed_reduction_force_ratio: Vector2 = Vector2(.75, .5)

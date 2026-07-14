@icon("uid://cph5y7calh2m")
extends Resource
class_name HitboxInformation


enum Type {
	KNOCKBACK,
	AERIAL,
	PUSHBACK,
	BLOWUP,
	POUND,
	DOWN_ATTACK,
}


const KNOCKBACK := Type.KNOCKBACK
const AERIAL := Type.AERIAL
const PUSHBACK := Type.PUSHBACK
const BLOWUP := Type.BLOWUP
const POUND := Type.POUND
const DOWN_ATTACK := Type.DOWN_ATTACK


@export_group("Attack Stat")
@export var atk_name: StringName = &""
@export var type: Type = Type.KNOCKBACK
@export var damage: int = 10
@export var damage_frame: int = 9
@export var force: Vector2 = Vector2(200., 0.)
@export var blockable: bool = true
@export var trace: bool = true
@export var max_available_unit_hit_count: int = 1


@export_group("Camera Effect Strength")
@export var camera_effect: CameraEffect


@export_group("When Blocked")
@export var block_effect: BlockEffect


@export_group("When Downed")
@export var downed_effect: DownAttackedEffect



	

# hit_result.gd
extends RefCounted
class_name HitResult


enum {
	KNOCKBACK,
	AERIAL
}

var type: int
var from: Node2D
var to: Node2D
var damage: int
var force: float
var effect_time: float

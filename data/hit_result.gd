# hit_result.gd
extends RefCounted
class_name HitResult


var from: Node2D
var to: Node2D
var attack_direction: float


static func create(_from: Node2D, _to: Node2D, dir: float) -> HitResult:
	var result := HitResult.new()
	
	result.from = _from
	result.to = _to
	result.attack_direction = dir
	
	return result

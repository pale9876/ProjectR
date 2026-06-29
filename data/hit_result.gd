# hit_result.gd
extends RefCounted
class_name HitResult


var from: Node2D
var to: Node2D


static func create(_from: Node2D, _to: Node2D) -> HitResult:
	var result := HitResult.new()
	
	result.from = _from
	result.to = _to
	
	return result

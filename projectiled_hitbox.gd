extends Area2D
class_name ProjectiledHitbox


@export var max_hit_count: int = 3

var spelled_by: Node2D


var hit_count: Dictionary[Node2D, int] = {}
var entered: Array[Node2D]


func _init() -> void:
	area_shape_entered.connect(_entered)


func _enter_tree() -> void:
	pass


func _entered(rid: RID, area: Area2D, shape_idx: int, local_idx: int) -> void:
	pass

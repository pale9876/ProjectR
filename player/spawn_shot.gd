extends Node2D



func add_projectile(scene: PackedScene, index: int) -> void:
	var stage := get_stage()
	var projectile := scene.instantiate() as Node2D
	stage.add_child(projectile)
	stage.move_child(projectile, index)


func get_stage() -> Stage:
	return get_unit().get_stage()


func get_unit() -> Replicator:
	return get_component().get_parent() as Replicator


func get_component() -> HitboxComponent:
	return get_parent() as HitboxComponent

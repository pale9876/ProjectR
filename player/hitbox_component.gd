# hitbox_component.gd
extends Node2D
class_name HitboxComponent


func get_hitbox(node_path: NodePath) -> PlayerHitbox:
	return get_node(node_path) as PlayerHitbox


func add_projectile(hitbox_scene: PackedScene) -> void:
	var _projectile := hitbox_scene.instantiate() as PlayerProjectiledHitbox
	add_child(_projectile)

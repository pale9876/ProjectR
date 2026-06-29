# hitbox_component.gd
extends Node2D


func get_hitbox(node_path: NodePath) -> PlayerHitbox:
	return get_node(node_path) as PlayerHitbox


func add(hitbox_scene: PackedScene) -> void:
	pass

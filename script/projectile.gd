@icon("uid://dduu0d6rht3d3")
extends CharacterBody2D
class_name Projectile


signal hit()


@export var speed: float = 550.
@export var max_gravity: float = 1550.
@export var accel: float = 22.25
@export var hitbox_info: HitboxInformation


var _spelled: Node2D


func _init() -> void:
	pass


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var point: Vector2 = collision.get_position()
		
		
		
		point.x

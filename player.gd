@tool
extends CharacterBody2D
class_name PhysicsUnit2D


@export var chara_info: CharacterInformation
@export var pose_controller: PoseController2D


var _pps: Vector2 = Vector2.ZERO


func _init() -> void:
	motion_mode == MOTION_MODE_GROUNDED
	up_direction = Vector2.UP
	collision_layer = 0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		#TODO:: WHAT
		return
	
	var collision: KinematicCollision2D = move_and_collide(
		velocity * delta
	)
	
	if collision:
		velocity = velocity.slide(collision.get_normal())
		var remainder_force: Vector2 = collision.get_remainder()
		if remainder_force:
			move_and_collide(remainder_force)
	
	

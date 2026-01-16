@tool
extends CharacterBody2D
class_name PhysicsUnit2D


@export var chara_info: CharacterInformation
@export var pose_controller: PoseController2D

@export var init_collider: CollisionShape2D
var _collider: Dictionary[StringName, CollisionShape2D] = {}
var _current: CollisionShape2D = null


func _init() -> void:
	motion_mode = MOTION_MODE_GROUNDED
	up_direction = Vector2.UP
	collision_layer = 0


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		_current = init_collider
		

func _ready() -> void:
	pass


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		for node: Node in get_children():
			if node is CollisionShape2D:
				_collider[node.name] = node


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


func get_collider_list() -> PackedStringArray:
	var result: PackedStringArray = []
	
	for node: Node in get_children():
		if node is CollisionShape2D:
			result.push_back(node.name)

	return result


func change_collider(c_name: String) -> bool:
	if !get_collider_list().has(c_name):
		return false
	
	for collider: CollisionShape2D in _collider.values():
		if collider.name == c_name:
			collider.visible = true
		else:
			collider.visible = false
	
	return true

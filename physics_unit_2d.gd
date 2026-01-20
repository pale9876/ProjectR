@tool
extends CharacterBody2D
class_name PhysicsUnit2D


@export var pose_controller: PoseController2D
@export var stat_handler: StatHandler
@export var init_collider: CollisionShape2D


var _collider: Dictionary[StringName, CollisionShape2D] = {}
var _current: CollisionShape2D = null


var _on_floor: bool = false
var _on_wall: bool = false



func get_information() -> UnitInformation:
	return stat_handler.information


func _init() -> void:
	motion_mode = MOTION_MODE_GROUNDED
	up_direction = Vector2.UP
	collision_layer = 0


func _enter_tree() -> void:
	if !Engine.is_editor_hint():
		_current = init_collider


func _update() -> void:
	_collider.clear()
	for node: Node in get_children():
		if node is CollisionShape2D:
			_collider[node.name] = node


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		_update()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		#TODO:: WHAT
		return
	
	if !_on_floor:
		velocity.y += get_gravity().y * delta

	while true: # move_and_slide
		var collision: KinematicCollision2D = move_and_collide(velocity * delta)
		if collision:
			var collide_object: Object = collision.get_collider()
			if collide_object is PhysicsUnit2D:
				pass
			
			var _normal: Vector2 = collision.get_normal()
			_on_floor = _normal.dot(velocity) == 0.
			velocity = velocity.slide(_normal)
		else:
			break


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

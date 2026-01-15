@tool
extends Node2D
class_name PoseController2D


@export var pose: Dictionary[StringName, Pose2D]
@export var init_pose: Pose2D


var _current: Pose2D = null


func _enter_tree() -> void:
	if !pose.is_empty(): pose.clear()


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	if init_pose != null:
		assert(has_pose(init_pose.name))
		assert(get_children().filter(func(node)->bool: return node is Pose2D).has(init_pose))
		change_pose(init_pose.name)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _current != null:
		_current._update(delta)


func _notification(what: int) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		pose.clear()
		for node: Node in get_children():
			if node is Pose2D:
				pose[node.name] = node
	elif what == NOTIFICATION_VISIBILITY_CHANGED:
		_visibility_changed_ev_handler()


func _visibility_changed_ev_handler() -> void:
	for node: Node in get_children():
		if node is Node2D:
			node.visible = visible


func remove_pose(_pose: Pose2D) -> bool:
	if !pose.has(_pose.name): return false
	
	pose.erase(_pose.name)
	return true


func add_pose(_pose: Pose2D) -> bool:
	if pose.has(_pose.name):
		return false
	
	pose[_pose.name] = _pose
	return true


func get_current_pose() -> Pose2D:
	return _current


func get_poses() -> Array[Pose2D]:
	return pose.values()


func get_list() -> PackedStringArray:
	var list: Array = pose.keys()
	var result: PackedStringArray = []
	
	for n: StringName in list:
		result.push_back(String(n))
	
	return result


func has_pose(pose_name: StringName) -> bool:
	return pose.has(pose_name)


func change_pose(pose_name: StringName) -> bool:
	if !has_pose(pose_name): return false
	
	var prev_pose: Pose2D = get_current_pose()
	var next_pose: Pose2D = pose[pose_name]
	
	if prev_pose != null:
		prev_pose._exit()
	
	for _pose: Pose2D in get_poses():
		if next_pose == _pose:
			_pose.disabled = false
			_pose._enter()
		else:
			_pose.disabled = true

	return true

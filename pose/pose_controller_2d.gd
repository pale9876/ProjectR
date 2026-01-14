@tool
extends Node2D
class_name PoseController2D


@export var cache: Dictionary[StringName, Pose2D]
@export var init_pose: Pose2D


var _current: Pose2D = null


func _enter_tree() -> void:
	if !cache.is_empty(): cache.clear()


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


func remove_pose(pose: Pose2D) -> bool:
	if !cache.has(pose.name): return false
	
	cache.erase(pose.name)
	return true


func add_pose(pose: Pose2D) -> bool:
	if cache.has(pose.name):
		return false
	
	cache[pose.name] = pose
	return true


func get_current_pose() -> Pose2D:
	return _current


func get_poses() -> Array[Pose2D]:
	return cache.values()


func get_list() -> PackedStringArray:
	var list: Array = cache.keys()
	var result: PackedStringArray = []
	
	for n: StringName in list:
		result.push_back(String(n))
	
	return result


func has_pose(pose_name: StringName) -> bool:
	return cache.has(pose_name)


func change_pose(pose_name: StringName) -> bool:
	if !has_pose(pose_name): return false
	
	var prev_pose: Pose2D = get_current_pose()
	var next_pose: Pose2D = cache[pose_name]
	
	if prev_pose != null:
		prev_pose._exit()
	
	for pose: Pose2D in get_poses():
		if next_pose == pose:
			pose.disabled = false
			pose._enter()
		else:
			pose.disabled = true

	return true

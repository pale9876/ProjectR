@tool
extends Node2D
class_name PoseController2D


@export var cache: Dictionary[StringName, Pose2D]

@export var init_pose: Pose2D
var _current: Pose2D = null


func _enter_tree() -> void:
	cache.clear()


func remove_pose(pose: Pose2D) -> bool:
	if !cache.has(pose.name): return false
	
	cache.erase(pose.name)
	return true


func add_pose(pose: Pose2D) -> bool:
	if cache.has(pose.name):
		return false
	
	cache[pose.name] = pose
	return true


func get_poses() -> Array[Pose2D]:
	return cache.keys()


func get_list() -> PackedStringArray:
	var list: Array = cache.keys()
	var result: PackedStringArray = []
	
	for n: StringName in list:
		result.push_back(String(n))
	
	return result


func has_pose(pose_name: StringName) -> bool:
	return cache.has(pose_name)


func change_pose(pose_name: StringName) -> void:
	if !has_pose(pose_name): return

	var next_pose = cache[pose_name]
	
	for pose: Pose2D in get_poses():
		pass

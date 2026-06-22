@tool
class_name YggdrasilTreeState
extends Resource

@export_storage var version: int
@export_storage var allocated_nodes: Array[int]

func _init():
	version = 1
	allocated_nodes = []

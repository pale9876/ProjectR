extends Node

func save_tree_state(tree: YggdrasilTree) -> void:
	if Engine.is_editor_hint():
		return
	
	DirAccess.make_dir_recursive_absolute("user://yggdrasil")
	var uid = ResourceLoader.get_resource_uid(tree.resource_path)
	var save_path = "user://yggdrasil/%s.tree" % uid
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if not file:
		return
	
	file.store_32(tree.tree_state.version)
	file.store_var(tree.tree_state.allocated_nodes)
	file.close()

func load_tree_state(tree: YggdrasilTree) -> void:
	if Engine.is_editor_hint():
		return
	
	DirAccess.make_dir_recursive_absolute("user://yggdrasil")
	var uid = ResourceLoader.get_resource_uid(tree.resource_path)
	var save_path = "user://yggdrasil/%s.tree" % uid
	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		return

	tree.tree_state.version = file.get_32()
	tree.tree_state.allocated_nodes = file.get_var()
	file.close()

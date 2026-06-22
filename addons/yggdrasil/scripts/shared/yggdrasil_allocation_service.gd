@tool
class_name YggdrasilAllocationService
extends YggdrasilBaseService

const Yggdrasil = preload("res://addons/yggdrasil/scripts/shared/yggdrasil.gd")

signal node_preallocated(node: YggdrasilNodeButton)
signal node_unpreallocated(node: YggdrasilNodeButton)

signal node_allocated(node: YggdrasilNodeButton)
signal node_deallocated(node: YggdrasilNodeButton)

signal refund_mode_entered
signal refund_mode_exited
signal node_refund_added(node: YggdrasilNodeButton)
signal node_refund_removed(node: YggdrasilNodeButton)

var preallocation_check: Callable
var allocation_check: Callable
var deallocation_check: Callable
var refund_check: Callable

var _preallocated_nodes: Array[int] = []
var _refund_nodes: Array[int] = []
var _refund_mode: bool = false

var _allocated_nodes:
		get: return _tree_data.tree_state.allocated_nodes

func load_tree(tree_data: YggdrasilTree) -> void:
	_tree_data = tree_data

	for node_id in _allocated_nodes:
		var node: YggdrasilNodeButton = _tree_view.nodes_service.get_node(node_id)
		node.allocated = true
		node.set_state(Yggdrasil.AllocationState.ACTIVE)
		node_allocated.emit(node)

func on_node_pressed(node: YggdrasilNodeButton) -> void:
	if _tree_data.preallocation:
		if _refund_mode:
			if _can_stage_for_refund(node):
				node.refund = true
				_refund_nodes.append(node.id)
				node_refund_added.emit(node)
			elif _refund_nodes.has(node.id) and _can_unstage_refund(node):
				node.refund = false
				_refund_nodes.erase(node.id)
				node_refund_removed.emit(node)
		else:
			if _can_preallocate(node):
				_preallocated_nodes.append(node.id)
				node.preallocated = true
				node_preallocated.emit(node)
			elif _is_valid_deallocation(node, _get_remaining_nodes(node.id, true)):
				_preallocated_nodes.erase(node.id)
				node.preallocated = false
				node_unpreallocated.emit(node)
	else:
		if _can_allocate(node):
			_allocated_nodes.append(node.id)
			node.allocated = true
			node_allocated.emit(node)
		elif _is_valid_deallocation(node, _get_remaining_nodes(node.id)):
			_allocated_nodes.erase(node.id)
			node.allocated = false
			node_deallocated.emit(node)

func confirm_preallocations() -> void:
	for node_id in _preallocated_nodes:
		var node: YggdrasilNodeButton = _tree_view.nodes_service.get_node(node_id)
		node.preallocated = false
		node.allocated = true
		node_allocated.emit(node)

	_preallocated_nodes.clear()

func clear_preallocations() -> void:
	for node_id in _preallocated_nodes:
		var node: YggdrasilNodeButton = _tree_view.nodes_service.get_node(node_id)
		node.preallocated = false
		node_unpreallocated.emit(node)

	_preallocated_nodes.clear()

func enter_refund_mode() -> void:
	_refund_mode = true
	_refund_nodes.clear()
	refund_mode_entered.emit()

func exit_refund_mode() -> void:
	for node_id in _refund_nodes:
		var node: YggdrasilNodeButton = _tree_view.nodes_service.get_node(node_id)
		node_refund_removed.emit(node)
	
	_refund_nodes.clear()
	_refund_mode = false
	refund_mode_exited.emit()

func confirm_refund() -> void:
	for node_id in _refund_nodes:
		var node: YggdrasilNodeButton = _tree_view.nodes_service.get_node(node_id)
		_allocated_nodes.erase(node.id)
		node.allocated = false
		node_deallocated.emit(node)

	_refund_nodes.clear()
	_refund_mode = false
	refund_mode_exited.emit()

func is_refund_mode() -> bool:
	return _refund_mode

func get_refund_nodes() -> Array[int]:
	return _refund_nodes.duplicate()

func _can_preallocate(node: YggdrasilNodeButton) -> bool:
	if preallocation_check and not preallocation_check.call():
		return false

	if node.allocated or node.preallocated:
		return false

	if node.is_root:
		return true

	var active_nodes = _get_active_nodes()

	for in_node_id in node.in_nodes:
		if active_nodes.has(in_node_id):
			return true

	for out_node_id in node.out_nodes:
		if active_nodes.has(out_node_id):
			return true

	return false

func _can_allocate(node: YggdrasilNodeButton) -> bool:
	if allocation_check and not allocation_check.call():
		return false

	if node.allocated:
		return false
	
	if node.is_root:
		return true

	for in_node_id in node.in_nodes:
		if _allocated_nodes.has(in_node_id):
			return true
	
	for out_node_id in node.out_nodes:
		if _allocated_nodes.has(out_node_id):
			return true

	return false

func _can_stage_for_refund(node: YggdrasilNodeButton) -> bool:
	if refund_check and not refund_check.call():
		return false

	if not node.allocated or _refund_nodes.has(node.id):
		return false

	var remaining: Array[int] = _allocated_nodes.filter(
		func(id): return id != node.id and not _refund_nodes.has(id)
	)

	return _is_valid_deallocation(node, remaining)

func _can_unstage_refund(node: YggdrasilNodeButton) -> bool:
	var remaining: Array[int] = _allocated_nodes.filter(
		func(id): return not _refund_nodes.has(id) or id == node.id
	)

	if remaining.size() == _allocated_nodes.size():
		return true

	return _is_valid_deallocation(node, remaining)

func _is_valid_deallocation(node: YggdrasilNodeButton, remaining: Array[int]) -> bool:
	if deallocation_check and not deallocation_check.call():
		return false

	if not node.allocated and not node.preallocated:
		return false

	if remaining.is_empty():
		return true

	var start_node: YggdrasilNodeButton = null
	for node_id in remaining:
		var n = _tree_view.nodes_service.get_node(node_id)
		if n.is_root:
			start_node = n
			break

	if start_node == null:
		return false

	var visited = {}
	var stack = []
	for node_id in remaining:
		var n = _tree_view.nodes_service.get_node(node_id)
		if n.is_root:
			stack.append(n)
			visited[n.id] = true

	while not stack.is_empty():
		var current_node = stack.pop_back()
		var neighbors = current_node.in_nodes + current_node.out_nodes
		
		for neighbor_id in neighbors:
			var neighbor_node = _tree_view.nodes_service.get_node(neighbor_id)
			if remaining.has(neighbor_node.id) and not visited.has(neighbor_node.id):
				visited[neighbor_node.id] = true
				stack.append(neighbor_node)

	for node_id in remaining:
		if not visited.has(node_id):
			return false

	return true

func _get_active_nodes() -> Array[int]:
	return _allocated_nodes + _preallocated_nodes

func _get_remaining_nodes(excluded_id: int, include_prealloc: bool = false) -> Array[int]:
	var base = _allocated_nodes
	if include_prealloc:
		base += _preallocated_nodes
	return base.filter(func(id): return id != excluded_id)

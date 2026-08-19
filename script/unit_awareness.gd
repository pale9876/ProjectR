@tool
extends Area2D


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


signal hostile_found()
signal hostile_lost()

signal ally_found()
signal ally_lost()

signal dead_body_found()
signal bloodstain_found() 



var _cache: Dictionary[Node2D, Timer] = {
	# body, Timer
}



func _init() -> void:
	monitorable = false
	monitoring = true
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(2, true)


func _enter_tree() -> void:
	if Engine.is_editor_hint(): return
	
	body_entered.connect(_entered)
	body_exited.connect(_exited)
	
	var unit := get_parent() as Unit
	unit.state.face_changed.connect(
		func() -> void:
			scale.x = unit.get_face()
	)



func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var unit := get_parent() as Unit
	


func _entered(body: Node2D) -> void:
	if get_target() == body:
		hostile_found.emit()


func _add_cache(target: Node2D) -> void:
	var _timer: Timer = Timer.new()
	_timer.timeout.connect(
		func() -> void:
			_timer.queue_free.call_deferred()
	)


func _erase_cache(target: Node2D) -> void:
	var _timer: Timer = _cache[target]
	_timer.queue_free()
	target.queue_free()


func _clear() -> void:
	for item: Node2D in _cache:
		_erase_cache(item)
	_cache = {}


func _exited(body: Node2D) -> void:
	if get_target() == body:
		pass
		#timer.start(6.)


func get_target() -> Node2D:
	return (get_parent() as Unit).get_target()


func set_target(node: Node2D) -> void:
	return (get_parent() as Unit).set_target(node)


func default() -> void:
	set_target(null)


func target_is_hostile(node: Node) -> bool:
	
	return false

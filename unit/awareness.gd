extends Area2D


# Import
const Player: Script = preload("uid://c2uxhumgng18h")


signal found()
signal lost()


@onready var timer: Timer = $AwarenessTimer


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


func _ready() -> void:
	timer.timeout.connect(
		func() -> void:
			lost.emit()
			default()
	)


func _process(_delta: float) -> void:
	var unit := get_parent() as Unit
	


func _entered(body: Node2D) -> void:
	if get_target() == body:
		if timer.time_left > 0.:
			timer.stop()
		print("found")
		found.emit()


func _exited(body: Node2D) -> void:
	if get_target() == body:
		timer.start(6.)


func get_target() -> Node2D:
	return (get_parent() as Unit).get_target()


func set_target(node: Node2D) -> void:
	return (get_parent() as Unit).set_target(node)


func default() -> void:
	set_target(null)

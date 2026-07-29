# jiggle_line.gd
@tool
extends Path2D


signal updated()


@export_category("Attribute")
@export_range(8, 64, 2) var curve_point: int = 16
@export var degree: float = 0.
@export var max_radius: float = 36.25
@export_flags_2d_physics var mask: int = 3

var _destination: Vector2
var _emitted: bool = false

# Step
var progress: float = 0.
var _step: int = 64
var progress_ratio: float = 1.:
	set(val):
		progress_ratio = clampf(val, 0., 1.)

var _finished: bool = false


@export_tool_button("Emit", '2D') var _emit: Callable = emit


func get_tessel() -> PackedVector2Array:
	return curve.tessellate(3)


func _ready() -> void:
	var line := get_texture()
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED


func _exit_tree() -> void:
	clear()


func emit(destination: Vector2, step: int = 16) -> void:
	_destination = destination
	_step = step
	
	_emitted = true


func _process(delta: float) -> void:
	pass


func add_point(value: Vector2) -> void:
	pass


func set_point_inout(value: Vector2, _index: int) -> void:
	var _point: Vector2 = curve.get_point_position(_index)
	var _ratio: float = _index / float(_step - 1)
	var _in: Vector2
	var _out: Vector2

	updated.emit()


func _physics_process(_delta: float) -> void:
	if _emitted:
		if !_finished:
			var fixed_step: float = 1. / float(_step)
			var collapse: Vector2 = _destination / fixed_step
			
			progress += fixed_step


func clear() -> void:
	progress = 0.
	get_projectile().global_position = global_position
	updated.emit()


func get_projectile() -> CharacterBody2D:
	return get_node(^"Projectile") as CharacterBody2D


func get_texture() -> Line2D:
	return get_node(^"TextureLine") as Line2D


	
	

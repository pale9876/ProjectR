@tool
extends Path2D

@export var playing: bool = false
@export var length: float
@export var speed_scale: float = 3.5


@onready var middle_path: Path2D = %MiddlePath
@onready var end_path: Path2D = %EndPath
@onready var middle: PathFollow2D = %Middle
@onready var end: PathFollow2D = %End


func _enter_tree() -> void:
	curve.changed.connect(
		func() -> void:
			var points: PackedVector2Array = curve.tessellate()
			(get_parent() as Line2D).points = points
	)


var m_rat: float = TAU * .46
var n_rat: float = TAU * .25


func _ready() -> void:
	curve.clear_points()
	
	curve.add_point(Vector2())
	curve.add_point(middle.global_position)
	curve.add_point(end.global_position)
	
	middle.progress = 1.15
	end.progress = .55


func _physics_process(delta: float) -> void:
	if !playing: return
	
	var speed: float = delta * speed_scale
	m_rat += speed
	n_rat += speed
	
	var prev: Vector2 = end_path.position + end.position
	var prev_ratio: float = end.progress_ratio
	
	middle.progress_ratio = (sin(m_rat) / 2. + .5) 
	end.progress_ratio = (sin(n_rat) / 2. + .5)
	
	var next: Vector2 = end_path.position + end.position
	var next_ratio: float = end.progress_ratio
	
	var dir: Vector2 = prev.direction_to(next)
	
	var end_point: Vector2 = end_path.position + end.position
	var middle_point: Vector2 = middle_path.position + middle.position
	var to_middle_length: float = 5.
	var rot_scale: float = 1.55
	var _scaled: float = middle_point.normalized().angle() * rot_scale
	
	curve.set_point_out(0, middle_point.normalized() * to_middle_length)
	curve.set_point_position(1, middle_point)
	curve.set_point_in(1, middle_point.normalized() * - 5.)
	curve.set_point_out(1, middle_point.normalized() * 5.)
	curve.set_point_position(2, end_point)
	curve.set_point_in(2, dir * (absf(next_ratio - prev_ratio) * 1225.))

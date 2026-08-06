# sprite_component.gd
@tool
extends Node2D

# Import
const DirectionModuler: Script = preload("uid://dghhexdudu0xy")


@export var current: DirectionModuler:
	set(path):
		current = path
		if is_inside_tree():
			if current:
				for node: Node in get_children():
					(node as DirectionModuler).visible = node == current


var force: Vector2
var time: float:
	set(value):
		time = maxf(0., value)
var time_scale: float:
	set(value):
		time_scale = maxf(0., value)


func _physics_process(delta: float) -> void:
	if time > 0.:
		force = - force
		
		position = position.lerp(force, randf_range(.125, .225))
		force = force.lerp(Vector2(), randf_range(.095, .225))
		time -= delta * time_scale


func has_module(_name: String) -> bool:
	return get_node(NodePath(_name)) in get_children()


func shake(_force: Vector2, _duration: float, _scale: float) -> void:
	force = _force
	time = _duration

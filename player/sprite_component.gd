# sprite_component.gd
@tool
extends Node2D


# Import
const DirectionModuler: Script = preload("uid://dghhexdudu0xy")


@export var current: KaradaModule:
	set(node):
		current = node
		#var node := get_node_or_null(path)
		if node and node.is_inside_tree():
			for child: Node in get_children():
				if child is KaradaModule:
					child.visible = node == child


@export var offset: Vector2 = Vector2(0., -64.):
	set(value):
		offset = value
		for node: Node in get_children():
			if node is KaradaModule:
				node.position = offset


var force: Vector2
var time: float:
	set(value):
		time = maxf(0., value)
var time_scale: float:
	set(value):
		time_scale = maxf(0., value)



func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
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

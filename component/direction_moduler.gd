@tool
extends Node2D


@export var hframes: int = 1:
	set(val):
		hframes = maxi(1, val)
		if is_inside_tree():
			propagate_hframes()

@export var vframes: int = 1:
	set(val):
		vframes = maxi(1, val)
		if is_inside_tree():
			propagate_vframes()

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_KEYING_INCREMENTS)
var frame: int = 0:
	set(val):
		frame = clampi(val, 0, hframes * vframes - 1)
		if is_inside_tree():
			get_current_sprite().frame = frame

@export_range(-1, 1, 2) var direction: int = 1:
	set(val):
		direction = clampi(val, -1, 1)
		if is_inside_tree():
			_update()

@export var offset: Vector2 = Vector2(0., 0.):
	set(value):
		offset = value
		if is_inside_tree():
			for node: Node in get_children():
				(node as Sprite2D).offset = offset


func _ready() -> void:
	_update()


func propagate_hframes() -> void:
	for node: Node in get_children():
		(node as Sprite2D).hframes = hframes


func propagate_vframes() -> void:
	for node: Node in get_children():
		(node as Sprite2D).vframes = vframes


func _update() -> void:
	var sprite: Sprite2D = get_current_sprite()
	sprite.frame = frame
	for node: Node in get_children():
		(node as Sprite2D).visible = sprite == node


func get_current_sprite() -> Sprite2D:
	return get_node(_get_dir_strpath()) as Sprite2D


func _get_dir_strpath() -> NodePath:
	match direction:
		-1:
			return ^"Left"
		1:
			return ^"Right"
	return ^""

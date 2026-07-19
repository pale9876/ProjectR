# icon_map.gd
@tool
extends Node


# Import
const Icon: Script = preload("uid://byx4j5csndsem")


enum Type
{
	NONE,
	START_POINT,
	CLOT,
	ENEMY,
	VICTIM,
	SUPPORTER,
	TRADER,
	EVENT_RANDOM,
	NPC_RANDOM,
}


const NONE := Type.NONE
const START_POINT := Type.START_POINT
const CLOT := Type.CLOT
const ENEMY := Type.ENEMY
const SUPPORTER := Type.SUPPORTER


const ICON_TEXTURE: Texture = preload("uid://btm6sfpgxylt2")


const ICON_COORD: Dictionary[Type, Vector2i] = {
	NONE : Vector2i(1, 0),
	START_POINT : Vector2i(2, 0),
	
}


@export var max_count: int = 255


func _enter_tree() -> void:
	pass


func arrange_by_data(data: Resource) -> void:
	pass


func set_icon(coord: Vector2, icon_coord: Vector2i) -> void:
	if get_child_count() == max_count:
		printerr("유닛 또는 이벤트를 더 이상 생성할 수 없습니다.")
		return
	
	var sprite: Icon = Icon.new()
	sprite.texture = ICON_TEXTURE
	sprite.global_position = coord
	
	add_child(sprite)



	

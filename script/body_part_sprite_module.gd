# body_part_sprite_module.gd
@tool
extends Node2D


@export_range(-1, 1, 2) var spin_direction: int = -1:
	set(val):
		spin_direction = clampi(val, -1, 1)




	

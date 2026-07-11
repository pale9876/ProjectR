# gunshot.gd
@icon("res://2d/projectiles-reticles/icon-gun-2d.svg")
extends Line2D


enum Type {
	RAY,
	SHAPE,
}

@export var type: Type = Type.RAY
@export var hitbox_info: HitboxInformation
@export_range(200., 1000., 1.) var range: float = 350.
@export var direction: Vector2


func shot() -> Dictionary:
	
	
	return {
		"collider" : null,
		"position" : Vector2(),
	}

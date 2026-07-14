# gunshot.gd
@icon("uid://baq3pmm1oy831")
@tool
extends Line2D
class_name ShotForm


enum Type {
	RAY,
	SHAPE,
}


@export var type: Type = Type.RAY
@export var shape: Shape2D
@export var hitbox_info: HitboxInformation
@export_range(200., 1000., 1.) var shot_range: float = 350.
@export var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value if value.is_normalized() else value.normalized()
@export_range(1., 3., .001) var additional_ratio: float = 1.
@export_flags_2d_physics var mask: int = 3


func shot() -> void:
	if Engine.is_editor_hint(): return
	
	match type:
		Type.RAY:
			pass
	var param := PhysicsRayQueryParameters2D.create(
		global_position, global_position + (shot_range * direction),
		mask, [get_unit_rid()]
	)
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(param)
	var cannon_shot: Vector2
	if !result.is_empty():
		var collider := result["collider"] as Object
		cannon_shot = result["position"] as Vector2
		if collider is StaticBody2D:
			pass
		elif collider is Unit:
			pass
	else:
		cannon_shot = shot_range * direction * additional_ratio



func create_ricochet() -> void:
	pass


func beam() -> void:
	if Engine.is_editor_hint(): return


func get_component() -> HitboxComponent:
	return get_parent() as HitboxComponent

func get_unit_rid() -> RID:
	return (get_component().get_parent() as CharacterBody2D).get_rid()

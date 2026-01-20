@tool
extends GPUParticles2D
class_name SnowParticle2D


const SNOW_PARTICLE_MATERIAL: Resource = preload("res://particle_material/snow_particle_material.tres")

@export var emit_margin: float = 0.: set = _set_margin
var _default_emission_box_value: Vector3 = Vector3(640., 125., 1.)

func _init() -> void:
	process_material = SNOW_PARTICLE_MATERIAL


func _set_margin(value: float) -> void:
	emit_margin = value
	if process_material != null:
		(process_material as ParticleProcessMaterial).emission_box_extents.x = _default_emission_box_value.x + emit_margin

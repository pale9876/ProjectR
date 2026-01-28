@tool
extends MultiMeshInstance2D
class_name PhysicsParticle2D


var id: int = -1:
	get(): id += 1; return id


func init_id() -> void:
	id = -1


func _init() -> void:
	pass


func _add_obj() -> void:
	if texture:
		var paticle: Particle = Particle.new(id, Vector2i.ZERO, texture.get_size())


func _physics_process(delta: float) -> void:
	pass


func collide_handler(id: int, velocity: Vector2, normal: Vector2) -> void:
	pass


class Particle extends RefCounted:
	var instance_id: int = -1
	var coord: Vector2i = Vector2i.ZERO
	var size: Vector2i = Vector2i.ZERO
	
	func _init(_id: int, _coord: Vector2i, _size: Vector2i) -> void:
		pass
	

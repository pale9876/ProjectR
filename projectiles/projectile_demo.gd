@tool
extends Endeka


var projectiles: Array[Projectile]
var thread_pool: Array[int]


func _process(_delta: float) -> void:
	pass


func add_projectile(from: Vector2, to: Vector2, motion: Vector2) -> void:
	var projectile: Projectile = Projectile.new()
	projectile.from = from
	projectile.to = to
	projectile.motion = motion
	
	# CID
	projectile.cid = RenderingServer.canvas_item_create()
	



class Projectile:
	var motion: Vector2
	var from: Vector2
	var to: Vector2
	
	var cid: RID
	var body: RID
	var shape: RID
	
	var task_id: int
	
	func next() -> void:
		from = from.move_toward(to, motion.length())


class HoamingProjectile extends Projectile:
	var max_angle: float = 5.
	var target: EEAD
	
	
	func next() -> void:
		pass

	func update_target() -> void:
		if target != null:
			pass


class RazorProjectile extends Projectile:
	pass






	

extends Node2D


var _objs: Array[Particle] = []


func _ready() -> void:
	_objs.push_back(
		Particle.new(global_position, - Vector2.ONE.normalized() * 1500., get_world_2d())
	)


func _move_particle(obj: Particle, delta: float) -> void:
	var motion_param: PhysicsTestMotionParameters2D = PhysicsTestMotionParameters2D.new()
	motion_param.from = Transform2D(0., obj.pos)
	motion_param.margin = .5
	motion_param.motion = obj.force * delta
	
	var result: PhysicsTestMotionResult2D = PhysicsTestMotionResult2D.new()
	
	var collide: bool = PhysicsServer2D.body_test_motion(
		obj._rid,
		motion_param,
		result
	)
		
	if collide:
		print("-------------------------------------------")
		print("!!collide!!")
		print(result.get_collider())
		print(result.get_collision_point())
		print(result.get_collision_normal())
		
		obj._collided = true
		
		obj.pos = result.get_collision_point() + (result.get_collision_normal() * obj._radius)
		obj.force = obj.force.bounce(result.get_collision_normal())
			
	else:
		obj.pos += motion_param.motion


func _physics_process(delta: float) -> void:
	for obj: Particle in _objs:
		_move_particle(obj, delta)
		
	queue_redraw()


func _draw() -> void:
	for obj in _objs:
		draw_circle(Vector2.ZERO + obj.pos, obj._radius, Color.BLUE)


func _exit_tree() -> void:
	for obj: Object in _objs:
		obj.free.call_deferred()


class Particle extends Object:

	var pos: Vector2 = Vector2.ZERO
	var _rid: RID
	var _shape: CircleShape2D
	var _radius: float = 30.
	var force: Vector2
	var _collided: bool = false


	func _init(_pos: Vector2, _force: Vector2, _world: World2D) -> void:
		pos = _pos
		force = _force
		
		_rid = PhysicsServer2D.body_create()
		_shape = CircleShape2D.new()
		
		PhysicsServer2D.body_set_space(_rid, _world.space)
		PhysicsServer2D.body_set_mode(_rid, PhysicsServer2D.BODY_MODE_KINEMATIC)
		_shape.radius = _radius
		PhysicsServer2D.body_add_shape(
			_rid,
			_shape,
		)

	func free() -> void:
		PhysicsServer2D.free_rid(_shape)
		PhysicsServer2D.free_rid(_shape)

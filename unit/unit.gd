extends Replicator
class_name Unit


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const Awareness: Script = preload("uid://bdj3moatwduju")


@export var info: UnitInformation
@export var rage_mode: bool = true


func get_face() -> float:
	return float(state.face.x)

#
#func get_anim() -> AnimationPlayer:
	#return get_node(^"AnimationPlayer") as AnimationPlayer


func _on_face_changed() -> void:
	get_sprite_component().scale.x = float(state.face.x)


func _enter_tree() -> void:
	GSignal.soft_pause.connect(soft_pause)
	GSignal.resume.connect(resume)
	
	# init hp
	stat.name = info.name
	stat.max_hp = info.hp
	stat.hp = stat.max_hp
	stat.speed = info.speed


func _ready() -> void:
	var hsm := get_state_machine()
	
	get_bt().active = false
	
	get_sprite_component().init_sprites(
		info.upper_motions,
		info.lower_motions,
		info.sprite_frames
	)
	
	hsm.initial_state = hsm.get_node(^"Idle") as LimboState
	hsm.initialize(self)
	hsm.set_active(true)



func get_collider() -> CollisionShape2D:
	return get_node(^"UnitCollision") as CollisionShape2D


func get_awareness_area() -> Awareness:
	return get_node(^"Awareness") as Awareness


func get_state_machine() -> LimboHSM:
	return get_node(^"StateMachine") as LimboHSM


func get_btbb() -> Blackboard:
	return get_bt().blackboard


func get_sprite() -> AnimatedSprite2D:
	return get_sprite_component().sprite


func get_hurtbox() -> Hurtbox:
	return get_node(^"Hurtbox") as Hurtbox


func get_target() -> Node2D:
	return get_btbb().get_var(&"target")


func set_target(node: Node2D) -> void:
	return get_btbb().set_var(&"target", node)


func get_bt() -> BTPlayer:
	return get_node(^"BTPlayer") as BTPlayer


func default() -> void:
	set_target(null)

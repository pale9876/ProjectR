extends CharacterBody2D
class_name BodyPart


func _init() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, false)


func _ready() -> void:
	var hsm := get_hsm()
	
	hsm.initialize(self)
	hsm.set_active(true)


func get_hsm() -> LimboHSM:
	return get_node(^"LimboHSM") as LimboHSM


func get_anim() -> AnimationPlayer:
	return get_node(^"AnimationPlayer") as AnimationPlayer

# pond_hitbox.gd
extends Area2D


func _init() -> void:
	monitoring = true
	monitorable = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(2, true)
	


func _enter_tree() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	pass

@icon("uid://baxmkbmm1hw0h")
extends Area2D
class_name GrabBox


func _init() -> void:
	visible = false


func _enter_tree() -> void:
	area_entered.connect(_entered)



func _exit_tree() -> void:
	area_entered.disconnect(_entered)


func _entered(area: Area2D) -> void:
	pass

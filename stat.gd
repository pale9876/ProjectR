# stat.gd
extends RefCounted
class_name Stat

signal expanded()
signal reduced()
signal damaged()
signal dead()
signal healed()
	
var _class: StringName = &""
var name: StringName = &""
var level: int = 0
var hp: int:
	set(value):
		hp = maxi(value, 0)
		if hp == 0:
			dead.emit()
var max_hp: int
var speed: float


func expand() -> void:
	expanded.emit()


func reduce() -> void:
	reduced.emit()


func damage(value: int) -> void:
	hp -= value
	damaged.emit()


func heal(value: int) -> void:
	hp += value
	healed.emit()

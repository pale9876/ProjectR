extends StaticBody2D


const Gate: Script = preload("uid://bhm55p84lxiok")


@onready var gate_left_up: Gate = $GateLeftUp
@onready var gate_left_down: Gate = $GateLeftDown
@onready var gate_up_left: Gate = $GateUpLeft
@onready var gate_up_right: Gate = $GateUpRight
@onready var gate_down_left: Gate = $GateDownLeft
@onready var gate_down_right: Gate = $GateDownRight
@onready var gate_right_up: Gate = $GateRightUp
@onready var gate_right_down: Gate = $GateRightDown


@export var room_rect: Vector2i = Vector2i.ONE


func _enter_tree() -> void:
	pass


func open_gate() -> void:
	pass

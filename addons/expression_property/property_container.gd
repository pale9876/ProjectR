@icon("res://ui/blocks/icon-block-container-ui.svg")
extends HBoxContainer


const ExpressionInformation: Script = preload("uid://bk70qxqhlnjop")


@onready var left: LineEdit = %Left
@onready var operand: OptionButton = %Operator
@onready var right: LineEdit = %Right


var op : Variant.Operator = OP_IN


func _init() -> void:
	pass


func get_sentence() -> String:
	var left_var: String = left.text
	var op: String = operand.text
	var right_var: String = right.text
	
	assert(!left_var.is_empty() and !op.is_empty() and !right_var.is_empty())
	
	return "left " + op + " right "


func parse() -> void:
	pass

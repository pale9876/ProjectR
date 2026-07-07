extends HBoxContainer


@onready var left_variable: LineEdit = %LeftVariable
@onready var option_button: OptionButton = %OptionButton
@onready var right_variable: LineEdit = %RightVariable


var expression: Expression


func _init() -> void:
	expression = Expression.new()


func get_expression() -> String:
	return ""


func parse() -> void:
	pass

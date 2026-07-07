# expression_information.gd
extends Resource
class_name StateGuard


var left: LimboState
var right: LimboState
var result: Error


var _expression: Expression = Expression.new()


func parse(sentense: String) -> Error:
	var err := _expression.parse(sentense, ["left", "right"])
	return err


func execute(instance: Node, left_var: Variant, right_var: Variant) -> Variant:
	return _expression.execute(
		[left_var, right_var], instance
	)

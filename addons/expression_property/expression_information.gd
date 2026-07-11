# expression_information.gd
extends Resource
class_name StateGuard


var left: Variant
var right: Variant
var result: Error


var _expression: Expression = Expression.new()

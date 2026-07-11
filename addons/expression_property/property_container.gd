@icon("res://ui/blocks/icon-block-container-ui.svg")
extends HBoxContainer


var hsm: LimboHSM = null


func _enter_tree() -> void:
	pass


func _ready() -> void:
	var key_type_option := %KeyType as OptionButton
	var key_option := %Key as OptionButton
	
	key_option
	
	key_type_option.item_selected.connect(
		func(idx: int) -> void:
			var text: String = key_type_option.get_item_text(idx)
			
	)



func get_guard() -> StateGuard:
	return StateGuard.new()


func get_key_type() -> String:
	return (get_node("%KeyType") as OptionButton).text


func get_blackboard_var() -> String:
	return ""


func get_limbo_state() -> LimboState:
	return


func get_key() -> Variant:
	match get_key_type():
		"Blackboard":
			return null
		"LimboState":
			return null
	
	return null


func get_op() -> String:
	return (get_node("%Operator") as OptionButton).text


func get_value_type() -> String:
	return (get_node("%ValueType") as OptionButton).text


func get_value() -> Variant:
	var text: String = (get_node("%Value") as LineEdit).text
	
	match get_value_type():
		"INT":
			assert(text.is_valid_int(), "유효하지 않은 정수값입니다.")
			return text.to_int()
	
		"FLOAT":
			assert(text.is_valid_float(), "유효하지 않은 실수값입니다.")
			return text.to_float()
		
		"String":
			return text
		
		"NodePath":
			return NodePath(text)
	
	return null


func parse() -> void:
	pass


func update() -> void:
	pass

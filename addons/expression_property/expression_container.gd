# property_container.gd
extends PanelContainer


const PROPERTY_CONTAINER: PackedScene = preload("uid://bnyv2bfyo3w2i")


@onready var add_expression: Button = %AddExpression


@onready var vbox_container: VBoxContainer = $MarginContainer/VBoxContainer


func _ready() -> void:
	add_expression.button_up.connect(
		func() -> void:
			var property_container := PROPERTY_CONTAINER.instantiate() as HBoxContainer
			vbox_container.add_child(property_container)
	)



	

extends Area2D


const Player: Script = preload("uid://c2uxhumgng18h")


@export var offset: float = 128.
@export var height: float = 200.
@export var dist: float = 300.
@export var range_ratio: float = 1.


@onready var polygon: CollisionPolygon2D = $CollisionPolygon2D


func set_polygon() -> void:
	var result: PackedVector2Array = PackedVector2Array()
	var center_point: Vector2 = Vector2(0., - offset)
	
	var top_left: Vector2 = center_point - Vector2(0., offset / 2.)
	var bottom_left: Vector2 = center_point + Vector2(0., offset / 2.)
	
	var top_right: Vector2 = Vector2()
	var bottom_right: Vector2
	


func _enter_tree() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)
	pass


func _ready() -> void:
	pass

func _entered(body: Node2D) -> void:
	if body is Player:
		(get_parent() as Unit).get_btbb().set_var(&"target", body)


func _exited(body: Node2D) -> void:
	if body is Player:
		(get_parent() as Unit).get_btbb().set_var(&"target", null)

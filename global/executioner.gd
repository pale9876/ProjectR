extends Node


var events: Array = []



func _physics_process(delta: float) -> void:
	pass


func _execute() -> void:
	pass


func append_ev(_from: Node, _to: Node, _ev: Dictionary) -> void:
	pass


static func create_ev(_from: Node, _to: Node, _ev: Dictionary) -> Event:
	var ev: Event = Event.new(_from, _to, _ev)
	return ev


class Event:
	var from: Node
	var to: Node
	var info: Dictionary
	
	func _init(_from: Node, _to: Node, _info: Dictionary) -> void:
		from = _from
		to = _to
		info = _info

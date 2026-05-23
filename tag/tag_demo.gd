@tool
extends Node


var keychain: KeyChain


func _enter_tree() -> void:
	var tag: T = T.new()
	tag.amount = 1.
	tag.dec = .1
	tag.duration = 1.
	tag.name = &"Hello"

	keychain = KeyChain.new()
	keychain.add_tag(tag)


func _process(delta: float) -> void:
	pass
	keychain.tick(delta)


class T extends Tag:
	func _entered() -> void:
		print("Tag Entered")

	func _exited() -> void:
		print("Tag Exited")
	
	func _invoke() -> void:
		print("hello")


class KC extends KeyChain:
	func _tag_entered(tag_name: StringName) -> void:
		pass
	
	func _tag_exited(tag_name: StringName) -> void:
		pass

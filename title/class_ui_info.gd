# class_info.gd
extends Resource
class_name ClassUIInfo


@export_group("Define")
@export var name: String
@export var icon: Texture
@export var portrait: Texture
@export_multiline() var description: String
@export var disabled: bool = false

@export_group("Stat")

@export var stat: Dictionary[String, int] = {
	"Aggressive" : 3,
	"Defensive" : 3,
	"Utility" : 3,
}

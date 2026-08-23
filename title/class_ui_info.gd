# class_info.gd
extends Resource
class_name ClassUIInfo


@export_group("Define")
@export var disabled: bool = false
@export var name: String
@export var icon: Texture
@export var portrait: Texture
@export_multiline() var description: String

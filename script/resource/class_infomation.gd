extends Resource
class_name ClassInformation



const BASE_DEF: int = 10
const BASE_ATK: int = 126

@export_group("UI")
@export var ui_info: ClassUIInfo


@export_group("Init Stats")
@export var init_hp: int
@export var init_speed: float
@export var base_atk: int = BASE_ATK
@export var base_def: int = BASE_DEF

@export_range(-5, 5, 1) var aggressive: int = 3
@export_range(-5, 5, 1) var defensive: int = 3
@export_range(-5, 5, 1) var utility: int = 3
@export var etc: Dictionary[String, Variant] = {
	
}


func get_class_meta() -> Dictionary[String, Variant]:
	var meta: Dictionary[String, Variant] = {}
	
	meta["aggressive"] = aggressive
	meta["defensive"] = defensive
	meta["utility"] = defensive
	meta.merge(etc)
	
	return meta

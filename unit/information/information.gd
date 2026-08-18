# information.gd for unit.stat
extends Resource
class_name UnitInformation


enum Race {
	UMONEIRA, # Human, DEFAULT
	NAITAM, # FoxEar, Tail
	GUOREO, # Long & Big Horn
	MONGOLIANA_CHILD, # 뾰족한 귀
	
	DICLONIUS, # ?
}

enum Nation {
	BYEONHAN_GUORE, # Korea, DEFAULT
	MANDAGAN, # Chinese
	ARIMIN, # Japanese
	SLAVONICA, # Russia Slav
	SUBORTEAR, # German,
}

enum CharacterClass {
	NONE, # DEFAULT
	
	PREDATOR,
	EXECUTIONER,
	CHIMERA,
	TRICKSTER,
	PUPPETEER,
	EXORCIST,
}


@export_group("외형 정보")
@export var race: Race = Race.UMONEIRA
@export var nation: Nation = Nation.BYEONHAN_GUORE

@export_group("캐릭터 및 클래스")
@export var is_replicant: bool = false
@export var unique: bool = false
@export var chara_class: CharacterClass = CharacterClass.NONE
@export var name: StringName = &""

@export_group("초기 스탯")
@export var speed: float = 200. # px / sec
@export var hp: int = 100

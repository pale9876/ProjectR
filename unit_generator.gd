# name_generator.gd
extends Node


enum Nation {
	IDU, # Korean
	MANA, # Japanese
	MANDARIN, # Chinese
	ULUS, # Mongolian
	RENOS, # German
}


enum Gender {
	FEMALE,
	MALE,
}


enum Race {
	IDLE, # Human
	KASANDRA, # Fox
	SERVUS, # Dog
	PECCATUM, # Eve
}


const UNIQUE_FNAME: PackedStringArray = [ # NPC의 이름이기에 제외되는 이름 목록
	"Hachi", # 살해 타겟 이름이라 
	"Eunseo", # 최종 책임관리자 A (Female)
	"Junwoo", # 최종 책임관리자 B (Male)
	"Fuwai", # 
	"ZhansiJeong", # 
]


func lname_variants(nation: Nation, race: Race) -> Dictionary[Nation, PackedStringArray]:
	return {
		Nation.IDU : PackedStringArray([
			"Li",
			"Jeong",
			"Na",
			"Yu",
		]),
		Nation.MANA : PackedStringArray([
			"Kayayowo",
			"Auko",
			"Noromi",
		]),
		Nation.MANDARIN : PackedStringArray([
			"Fei",
			"Chen",
			"Wu",
		]),
		Nation.ULUS : PackedStringArray([
			"Kantas",
			"Aduas",
			"Timon",
		]),
		Nation.RENOS : PackedStringArray([
			"Johnahan",
			"Hexsen",
			"Mainz",
			"Koln"
		]),
	}


func male_fname_variants(nation: Nation) -> PackedStringArray:
	assert(nation in [Nation.IDU, Nation.MANA, Nation.MANDARIN])
	
	const _VARS: Dictionary[Nation, PackedStringArray] = {
		Nation.IDU : [
			"Yungi",
		],
		Nation.MANA : [
			""
		],
		Nation.MANDARIN : [
			
		]
		
	}
	
	return _VARS[nation]


func female_fname_variants(nation: Nation) -> PackedStringArray:
	assert(nation in [Nation.IDU, Nation.MANA, Nation.MANDARIN])
	const _DICT: Dictionary[Nation, PackedStringArray] = {
		Nation.IDU : [
			"Eunseo"
		],
		Nation.MANA : [
			
		],
		Nation.MANDARIN : [
			
		]
	}
	return _DICT[nation]


func generate(gender: Gender,nation: Nation) -> StringName:
	assert(nation in [Nation.IDU, Nation.MANA, Nation.MANDARIN])
	
	var f_name: StringName = (female_fname_variants(nation) if gender == Gender.FEMALE else male_fname_variants(nation) as Array[String]).pick_random()
	var l_name: StringName = (lname_variants(nation, Race.IDLE)[nation] as Array[String]).pick_random()
	var full_name: StringName = l_name + &" " + f_name
	
	return full_name

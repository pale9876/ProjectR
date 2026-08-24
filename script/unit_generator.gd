# unit_generator.gd
extends Node


# Types
const Nation := UnitInformation.Nation
const Race := UnitInformation.Race


const UNIQUE_FNAME: Array[String] = [ # NPC의 이름이기에 제외되는 이름 목록
	"Hachi", # 살해 타겟 이름이라 
	"Eunseo", # 최종 책임관리자 A (Female)
	"Junwoo", # 최종 책임관리자 B (Male)
	"Fuwai", # 
	"Zhan-si Jeong", # 
]


func lname_variants(nation: Nation, race: Race) -> Dictionary[Nation, Array]:
	return {
		Nation.BYEONHAN_GUORE : [
			"Li",
			"Jeong",
			"Na",
			"Yu",
		],
		Nation.EMPIRE_ARIMIN : [
			"Kayayowo",
			"Auko",
			"Noromi",
		],
		Nation.MANDAGAN : [
			"Fei",
			"Chen",
			"Wu",
		],
		Nation.SLOVANACCI : [
			"Kantas",
			"Aduas",
			"Timon",
		],
		Nation.SUBORTEAR : [
			"Johnahan",
			"Hexsen",
			"Mainz",
			"Koln"
		],
	}


#func male_fname_variants(nation: Nation) -> PackedStringArray:
	#assert(nation in [Nation.IDU, Nation.MANA, Nation.MANDARIN])
	#
	#const _VARS: Dictionary[Nation, PackedStringArray] = {
		#Nation.IDU : [
			#"Yungi",
		#],
		#Nation.MANA : [
			#""
		#],
		#Nation.MANDARIN : [
			#
		#]
		#
	#}
	#
	#return _VARS[nation]


#func female_fname_variants(nation: Nation) -> PackedStringArray:
	#assert(nation in [Nation.IDU, Nation.MANA, Nation.MANDARIN])
	#const _DICT: Dictionary[Nation, PackedStringArray] = {
		#Nation.IDU : [
			#"Eunseo"
		#],
		#Nation.MANA : [
			#
		#],
		#Nation.MANDARIN : [
			#
		#]
	#}
	#return _DICT[nation]


#func generate(gender: Gender,nation: Nation) -> StringName:
	#assert(nation in [Nation.IDU, Nation.MANA, Nation.MANDARIN])
	#
	#var f_name: StringName = (female_fname_variants(nation) if gender == Gender.FEMALE else male_fname_variants(nation) as Array[String]).pick_random()
	#var l_name: StringName = (lname_variants(nation, Race.IDLE)[nation] as Array[String]).pick_random()
	#var full_name: StringName = l_name + &" " + f_name
	#
	#return full_name

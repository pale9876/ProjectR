@tool
extends Node
class_name StatHandler


const INFORMATION_PLACEHOLDER: UnitInformation = preload("uid://4ntuwag3k035")
const STAT_PLACEHOLDER: CharacterStat = preload("uid://d0fhc3kbwh5sj")


@export var information: UnitInformation
@export var stat: CharacterStat


func _init() -> void:
	information = INFORMATION_PLACEHOLDER
	stat = STAT_PLACEHOLDER

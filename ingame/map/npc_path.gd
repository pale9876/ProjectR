# npc_path.gd
extends Path2D
class_name NPCPath


const NPC_TEMPLETE_SCENE: PackedScene = preload("uid://b7ya2gtphhn00")
const PathedUnit: Script = preload("uid://dqd845y1secly")


func add_unit(info: UnitInformation, progress: float = 0.) -> void:
	var npc: PathedUnit = NPC_TEMPLETE_SCENE.instantiate()
	npc.info = info
	add_child(npc)
	npc.progress = progress

extends Control

@export var dialogue: DialogueResource
var _dialogue_line: DialogueLine

@onready var dialogue_label: DialogueLabel = $DialogueLabel

func _enter_tree() -> void:
	DialogueManager.mutated.connect(_on_mutated)
	DialogueManager.dialogue_ended.connect(_finished)


func _ready() -> void:
	_dialogue_line = await DialogueManager.get_next_dialogue_line(
		dialogue, "start"
	)
	
	dialogue_label.text = _dialogue_line.text
	

func _get_next() -> void:
	_dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue)
	

func _on_mutated(mutation: Dictionary) -> void:
	pass


func _finished(d_resource: DialogueResource) -> void:
	print("Finished")

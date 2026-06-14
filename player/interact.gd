# player/interact.gd
extends Area2D

# Import
const NPC: Script = preload("uid://btmmen2m5ofg7")
const Player: Script = preload("uid://c2uxhumgng18h")

# Bodies interacting with player
var interacting: Array[Node2D] = []


func _enter_tree() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)
	
	var unit: Player = get_parent() as Player
	
	unit.state.on_face_changed.push_back(
		func() -> void:
			var rad: float = Vector2(unit.state.face).angle()
			self.rotation = rad
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("interact") and !event.is_echo():
			if !interacting.is_empty():
				await get_tree().physics_frame

				Global.start_dialog(
					(interacting[0] as NPC), "greeting", "GREETING"
				)


func _entered(body: Node2D) -> void:
	if body is NPC:
		print("NPC Interact Area entered => ", body.name)
		interacting.push_back(body)


func _exited(body: Node2D) -> void:
	if interacting.has(body):
		print("NPC Interact Area exited => ", body.name)
		interacting.erase(body)

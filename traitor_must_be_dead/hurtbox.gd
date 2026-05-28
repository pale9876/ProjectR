extends Area2D


const Hitbox: Script = preload("uid://qce0gi6r23ds")


func _enter_tree() -> void:
	var node: Node = get_parent()
	area_entered.connect(on_area_entered.bind(node))
	

func on_area_entered(area: Area2D, parent: Node) -> void:
	if area is not Hitbox: return
	
	var hitbox: Hitbox = area as Hitbox

	if parent is Player:
		parent.damaged(hitbox.current)
	
	
	

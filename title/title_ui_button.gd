# title_ui_button.gd
extends Button


@onready var anim: AnimationPlayer = $AnimationPlayer


func _init() -> void:
	mouse_entered.connect(
		func() -> void:
			anim.play(&"hover")
	)
	
	mouse_exited.connect(
		func() -> void:
			pass
	)


#func _ready() -> void:
	#anim.play(&"Idle")
	#anim.animation_finished.connect(
		#func(_anim_name: StringName) -> void:
			#if _anim_name == &"":
				#pass
			#
	#)


	

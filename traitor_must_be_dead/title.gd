extends CanvasLayer


@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	anim.play("title_fade_in")
	await get_tree().create_timer(4.).timeout
	anim.play("title_fade_out")

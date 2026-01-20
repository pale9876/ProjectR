extends CanvasLayer


@onready var title_label: TweenAnimatedLabel = $Control/CenterContainer/Control/TitleLabel


func _ready() -> void:
	title_label.current = TweenAnimatedLabel.INIT


func _enter_tree() -> void:
	pass

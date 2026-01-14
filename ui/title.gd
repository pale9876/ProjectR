extends CanvasLayer


@onready var title_label: TweenAnimatedLabel = $Control/CenterContainer/Control/TitleLabel


func _init() -> void:
	title_label.current = TweenAnimatedLabel.INIT


func _enter_tree() -> void:
	pass

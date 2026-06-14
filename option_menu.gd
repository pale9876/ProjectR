extends CanvasLayer


const resolutions: PackedVector2Array = [
	Vector2(640, 360),
	Vector2(1280, 720)
]

@onready var resolution: OptionButton = %Resolution

@onready var master_volumn: HSlider = %MasterVolumn
@onready var sfx_volumn: HSlider = %SFXVolumn

@onready var close: Button = %Close


func _init() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _ready() -> void:
	for i: int in range(resolutions.size()):
		resolution.add_item(
			"x: " + str(int(resolutions[i].x)) + " y: " + str(int(resolutions[i].y)), i
		)
	
	resolution.item_selected.connect(_new_reolution_selected)
	master_volumn.value_changed.connect(vol_changed)
	sfx_volumn.value_changed.connect(sfx_vol_changed)


func _new_reolution_selected() -> void:
	pass


func vol_changed(value: float) -> void:
	const min_db: float = -72.
	const max_db: float = 6.


func sfx_vol_changed(value: float) -> void:
	const min_db: float = -72.
	const max_db: float = 6.

	

# blood_module_editor.gd
extends Control


@onready var import: Button = %Import
@onready var export: Button = %Export


@onready var target_grid: Node2D = %TargetGrid
@onready var karada_module_scene_loader: FileDialog = %KaradaModuleSceneLoader


@onready var information: TabBar = %Information
@onready var sprite: TabBar = %Sprite
@onready var hitbox: TabBar = %Hitbox
@onready var hurtbox: TabBar = %Hurtbox


func _ready() -> void:
	import.button_up.connect(
		func() -> void:
			karada_module_scene_loader.popup_centered()
	)
	
	export.button_up.connect(
		func() -> void:
			var packed_hitbox: PackedScene = PackedScene.new()
			
			var anim: Animation = parse()
			ResourceSaver.save(anim, "")
	)


func add_preview_sprite() -> void:
	pass



func parse() -> Animation:
	var anim := Animation.new()
	
	return anim

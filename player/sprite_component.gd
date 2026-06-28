# sprite_component.gd
extends Node2D


const SpriteModuler: Script = preload("uid://dbcsuysfwo30x")


@export var moduler: SpriteModuler
@export var sprite: AnimatedSprite2D



func init_sprites(
	_upper: SpriteFrames,
	_lower: SpriteFrames,
	_sprite: SpriteFrames
) -> void:
	moduler.upper.sprite_frames = _upper
	moduler.lower.sprite_frames = _lower
	sprite.sprite_frames = _sprite


func _ready() -> void:
	moduler.hide()
	sprite.hide()


func play_modules(anim_name: StringName) -> void:
	moduler.play(anim_name)
	moduler.show()
	sprite.hide()
	


func play(anim_name: StringName) -> void:
	sprite.play(anim_name)
	moduler.hide()
	sprite.show()


func shake() -> void:
	pass

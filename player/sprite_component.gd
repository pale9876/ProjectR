# sprite_component.gd
extends Node2D


const SpriteModuler: Script = preload("uid://dbcsuysfwo30x")


@export var moduler: SpriteModuler
@export var sprite: AnimatedSprite2D


var force: Vector2
var time: float:
	set(value):
		time = maxf(0., value)
var time_scale: float:
	set(value):
		time_scale = maxf(0., value)


func init_sprites(
	_upper: SpriteFrames,
	_lower: SpriteFrames,
	_sprite: SpriteFrames
) -> void:
	moduler.upper.sprite_frames = _upper
	moduler.lower.sprite_frames = _lower
	sprite.sprite_frames = _sprite


func _ready() -> void:
	sprite.show()
	moduler.hide()


func _physics_process(delta: float) -> void:
	if time > 0.:
		force = - force
		
		position = position.lerp(force, randf_range(.125, .225))
		force = force.lerp(Vector2(), randf_range(.095, .225))
		time -= delta * time_scale


func play_modules(anim_name: StringName) -> void:
	moduler.play(anim_name)
	moduler.show()
	sprite.hide()
	


func play(anim_name: StringName) -> void:
	sprite.play(anim_name)
	moduler.hide()
	sprite.show()


func shake(_force: Vector2, _duration: float, _scale: float) -> void:
	force = _force
	time = _duration

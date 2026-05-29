extends CharacterBody2D


const PlayerInfo: Script = preload("uid://duug3d6huidwq")
const Hurtbox: Script = preload("uid://cdfrjic0ld84i")


enum State {
	IDLE,
	HURT,
}


@export var info: PlayerInfo


var state: State = State.IDLE
var chara_stat: CharacterStat = CharacterStat.new()
var input_state: InputState = InputState.new()


@onready var hsm: LimboHSM = $LimboHSM


func _ready() -> void:
	hsm.initialize(self)
	hsm.set_active(true)


func _physics_process(delta: float) -> void:
	if input_state.direction != Vector2.ZERO:
		pass

	if state == State.IDLE:
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_echo() and event.is_pressed():
		input_state.direction = Input.get_vector("left", "right", "up", "down").normalized()
		input_state.push_dir()
		await get_tree().physics_frame
		print(input_state.key_log)



func damaged(res: Resource) -> void:
	pass



class CharacterStat:
	var speed: float
	var max_hp: int
	var hp: int


class InputState:
	var direction: Vector2
	var key_log: PackedStringArray
	var max_log: int = 10


	func _init() -> void:
		direction = Vector2.ZERO
		key_log = PackedStringArray()
		key_log.resize(max_log)


	func push_dir() -> void:
		var parse: Callable = func() -> String:
				match Vector2i(direction.ceil()):
					Vector2i.UP:
						return "up"
					Vector2i.DOWN:
						return "down"
					Vector2i.LEFT:
						return "left"
					Vector2i.RIGHT:
						return "right"
					_:
						return ""

		# 로그가 비어져있을 때 해당 칸에 빈 데이터 채우기
		if key_log[max_log - 1].is_empty():
			for i: int in range(max_log):
				if key_log[i].is_empty():
					var value = parse.call() as String
					key_log[i] = value
					return
		else:
			var value = parse.call() as String
			
			# 맨 앞의 데이터 지우고 데이터들 앞으로 당기기
			for i: int in range(max_log - 1):
				key_log[i] = key_log[i + 1]
			
			key_log[max_log - 1] = parse.call() as String

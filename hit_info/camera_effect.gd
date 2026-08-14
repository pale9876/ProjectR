extends Resource
class_name CameraEffect

@export_range(0., 1., .001) var shake_strength: float = .1 # 공격자 카메라 흔들림 강도
@export var reverse_shake_strength: float = 45. # 피격자 카메라 흔들림 강도

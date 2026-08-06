# ingame.gd
extends CanvasLayer


# Import
const MapKeikai: Script = preload("uid://o348jlsiq2tc")
const World: Script = preload("uid://dpn1opeegcme2")


# Enum
enum Calamity { # 재앙, 인게임 내에 고정 및 분위
	DAILY, # 일상 ( 미구현 )
	# 내부 NPC 비중이 높음
	# 외부 NPC 없음.
	# 적 유닛이 없음.
	
	TRAINING, # 연습 (튜토리얼)
	# 
	
	
	
	POSSESSION, # 집단적인 빙의
	# 내부 NPC 비중이 높음
	# 외부 NPC 없음.
	# 적 유닛 비중이 높음.
	# 전투 NPC 비중이 기매우 낮음.
	
	
	BREACHED, # 격리 실패
	# 맵에 시체 이벤트 비중이 높음
	# 전투 NPC 비중이 높음.
	# 적 유닛 비중이 높음.
	# 외부 NPC 없음.
	
	
	MASSACRE, # 학살
	# 맵에 시체 이벤트 비중이 높음.
	# 외부 NPC 비중이 높음.
	# 적 유닛 비중이 높음.
	
	
	MASS_SUICIDE, # 집단 자살
	#내부 NPC, 시체 비중이 높음 / 외부 NPC 없음.
	
	
	CROSSFIRE, # 교전
	# 내외부 NPC 비중이 높음. / 내외부 NPC 시체 비중이 높음. / 전투 NPC 비중이 높음
	
	
	DESCEND, # 강림
	# 이벤트 비중이 높음.
}


enum Leviathan { 
	# 인게임 내 랜덤으로 발현되는 이벤트, 게임오버 조건이 추가됨.
	# =====================================
	# 공통 게임오버 조건
	# > 플레이어의 죽음
	# > 현재 지역 탈출
	# =====================================
	
	NONE, # 없음
	# Calamity > [DAILY, TRAINING] 중 하나 선택
	# 스토리 목표 달성 시 게임 오버
	
	
	MINDULLE, # 민들레
	# 죽일 수 없는 원혼이 플레이어를 따라 이동하며 지역 이벤트 발생시킴.
	# ====================================
	# 추가 게임 오버 조건
	# > 이요람 (Lee Yoram) 사살
	# > 플레이어 컨트롤 타워(Mimana)의 사살
	# ====================================
	# Calamity > [MASS_SUICIDE, DESCEND] 중 하나 선택.
	
	
	PUPPETEER, # 인형사
	# 모든 적 유닛이 인형으로 변함.
	# ====================================
	# 추가 게임 오버 조건
	# > 인형사(유닛) 2명 사살
	# > 연구원 NPC '하치(Hachi)' 사살
	# ====================================
	# Calamity > [POSSESSION, BREACHED] 중 하나 선택.
	
	
	IMPERIAL_ORDER, # 
	# 외부로부터 들어온 전투 NPC로부터 침략당함.
	# ====================================
	# 추가 게임 조건
	# > 현장 지휘관 레이(Rei)를 포함한 적 유닛 사살
	# > 현재 지역 멜트 다운
	# ====================================
	# Calamity > [MASSACRE, CROSSFIRE] 중 하나 선택.
}


# Consts
const EV_PUPPETEER_DEAD: String = "Puppeteer Dead"
const EV_TRAINING_END: String = "Training End"
const EV_PLAYER_DEATH: String = "Player Death"


# Consts(Calamity)
const DAILY := Calamity.DAILY
const TRAINING := Calamity.TRAINING


# Consts(Leviathan)
const MINDULLE := Leviathan.MINDULLE


# Signal (to Global)
signal game_over (by_event: String) #



var calamity: Calamity = Calamity.DAILY
var leviathan: Leviathan = Leviathan.NONE


func set_lev(_lev: Leviathan) -> void:
	assert(_lev != Leviathan.NONE)
	
	var _calamity: Calamity
	
	match _lev:
		Leviathan.MINDULLE:
			_calamity = [
				Calamity.MASS_SUICIDE,
				Calamity.DESCEND,
			].pick_random()
		Leviathan.PUPPETEER:
			_calamity = [
				Calamity.BREACHED,
				Calamity.POSSESSION
			].pick_random()

		Leviathan.IMPERIAL_ORDER:
			_calamity = [
				Calamity.MASSACRE,
				Calamity.CROSSFIRE
			].pick_random()
	
	set_lev_with_cal(_lev, _calamity)



func _init() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	follow_viewport_enabled = true
	
	calamity = Calamity.values().pick_random()


func puppeteer_dead() -> void:
	game_over.emit("EV_PUPPETEER_DEAD")


func load_leviathan() -> void:
	pass


func set_lev_with_cal(_lev: Leviathan, _cal: Calamity) -> void:
	leviathan = _lev
	calamity = _cal


func get_keikai() -> MapKeikai:
	return get_node(^"%Keikai") as MapKeikai


func get_world() -> World:
	return get_node(^"%World") as World


func get_probability() -> Dictionary:
	return { }

func get_ev_probability() -> Dictionary:
	return { }

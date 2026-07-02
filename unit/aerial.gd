extends UnitState



func event(info: HitboxInformation) -> void:
	match info.type:
		HitboxInformation.AERIAL:
			pass
	

extends Node

# 
signal start()
signal open_settings()


# Soft Paused
signal soft_pause()
signal resume()



# Player
signal damaged(value: float)
signal healed(value: float)
signal dead()


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

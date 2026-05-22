@tool
extends Endeka
class_name Channel


const AudioPlayer: Script = preload("uid://eu0l5sa8mk4e")
const AudioListener: Script = preload("uid://dnj8oqfcuw010")


@export var listener: AudioListener


func play(stream_info: StreamInformation = StreamInformation.new()) -> void:
	var player: AudioPlayer = AudioPlayer.new()
	
	player.position = stream_info.pos
	player.stream = stream_info.stream
	player.bus = stream_info.bus
	player.volume_db = stream_info.volumn_db
	player.max_distance = stream_info.max_dist
	player.unit_size = stream_info.unit_size
	player.duration = stream_info.duration
	
	add_child(player)
	player.owner = self

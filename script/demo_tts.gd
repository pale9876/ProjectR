@tool
extends AudioStreamPlayer


@export_tool_button("Gen","AudioStreamPlayer") var _generate: Callable = generate


func generate() -> void:
	var gen := TTS079G2PEngine.new()
	var text: String = gen.g2p_sentence("they dont know how it works.")
	var tts: TTS079 = TTS079.new()
	var wav_data: PackedByteArray = tts.synthesise(text)
	var stream_16bits: PackedByteArray = PackedByteArray()
	stream_16bits.resize(wav_data.size() * 2)
	for i: int in wav_data.size():
		stream_16bits[(i * 2) + 1] = wav_data[i] ^ 0x80
	var _stream := AudioStreamWAV.new()
	_stream.data = stream_16bits
	_stream.format = AudioStreamWAV.FORMAT_16_BITS
	_stream.mix_rate = 6622
	_stream.stereo = false
	stream = _stream
	play()

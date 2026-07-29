@icon("icon.jpg")
class_name TTS079

# ── Speed table (CS_SYNTH:0x012A, confirmed) ──────────────────────────────────
# Index 5 (10000) is the unvoiced sentinel: pass waveform through without
# period-length adjustment. All other indices give a target period in samples.

const SPEED_TABLE := [32, 36, 43, 56, 96, 10000, 128, 64, 42, 32]
const DEFAULT_SPEED_IDX := 4      # → 96 samples, 89 Hz
const DEFAULT_A76 := 4      # per-phoneme pitch index; uniform default (see §8.6)
const UNVOICED_SENTINEL := 10000

# Maps SBTALKER pitch parameter (0–9) to DEFAULT_A76.
# Calibrated from recordings: pitch_0→period≈194(a76=6), pitch_5→94(a76=4), pitch_9→54(a76=3).
const A76_BY_PITCH := [6, 6, 5, 5, 4, 4, 4, 4, 3, 3]

# ── Phoneme name → synthesis index ────────────────────────────────────────────

const PHON_IDX := {
	'SIL':0,  'IH':1,  'IX':2,  'EH':3,  'AE':4,
	'AH':5,  'AX':6,  'AA':7,  'UH':8,  'OW':9,
	'AO':10, 'B_P':11, 'P':12, 'T_B':13, 'TX':14,
	'T':15,  'K':16,  'KX':17, 'BND':18, 'D':19,
	'G':20,  'F':21,  'TH':22,  'S':23,  'SH':24,
	'V':25,  'DH':26,  'Z':27,  'ZH':28,  'L':29,
	'M':30,  'N':31,  'NG':32,  'Y':33,  'HH':34,
	'R':35,  'W':36,  'AY':37,  'EY':38,  'IY':39,
	'UW':40, 'OY':41,  'AW':42,  'ER':43,
}

const CONS_IDX := {
	'b':18, 'd':19, 'f':21, 'g':20, 'h':34, 'k':16,
	'l':29, 'm':30, 'n':31, 'p':11, 'r':35, 's':23,
	't':13, 'v':25, 'w':36, 'y':33, 'z':27,
}

var TT: Dictionary
var SL: Dictionary
var blocks: Array[PackedByteArray] = []

class Samples:
	var samples: PackedByteArray

func _init() -> void:
	_load_blocks()
	var file = FileAccess.open("res://addons/tts_079/data/tables.json", FileAccess.READ)
	var tables: Dictionary = JSON.parse_string(file.get_as_text())
	TT = tables['transition_table']   # key "L,R" → {t1, t1_rev, t2, t2_rev}
	SL = tables['segment_lists']      # key "ptr_int" → list of entries
	for e in SL:
		for b in SL[e]:
			b.block_idx = int(b.block_idx)


func _load_blocks() -> void:
	var buf := FileAccess.get_file_as_bytes("res://addons/tts_079/data/blocks.bin")
	var pos := 0
	var n := buf.size()
	while pos < n:
		var ln: int = buf[pos]
		blocks.append(buf.slice(pos + 1, pos + 1 + ln))
		pos += 1 + ln
	# blocks[idx] now holds the PCM for segment.block_idx == idx

# ── x86 16-bit arithmetic helpers ─────────────────────────────────────────────
# These mirror the exact integer semantics of the 8088/8086 instructions used
# in SBTALKER's synthesis engine, preventing silent divergence from Python's
# arbitrary-precision integers.

func s8(v:int) -> int:
	"""Reinterpret low 8 bits as a signed byte (−128 … 127)."""
	v &= 0xFF
	return v if v < 128 else v - 256

func u8(v:int) -> int:
	"""Mask to unsigned byte (0 … 255)."""
	return v & 0xFF

func s16(v:int) -> int:
	"""Reinterpret low 16 bits as a signed word (−32768 … 32767)."""
	v &= 0xFFFF
	return v if v < 0x8000 else v - 0x10000

func u16(v:int) -> int:
	"""Mask to unsigned word (0 … 65535)."""
	return v & 0xFFFF

func add8(a:int, b:int) -> int:
	"""8-bit wrapping addition → signed result."""
	return s8((a + b) & 0xFF)

func sub8(a:int, b:int) -> int:
	"""8-bit wrapping subtraction → signed result."""
	return s8((a - b) & 0xFF)

func sar8(v:int, n:int) -> int:
	"""Arithmetic right shift of a signed 8-bit value (equivalent to x86 SAR r8,n)."""
	v = s8(v)
	return v >> n   # Python >> on negative integers is arithmetic

func idiv_trunc(num:int, den:int) -> int:
	"""Integer division truncated toward zero, matching x86 IDIV."""
	return int(num / den)

# ── G2P string → [(phoneme_idx, speed_index)] ─────────────────────────────────

func is_upper(character: String) -> bool:
	var word_re := RegEx.new()
	word_re.compile("[A-Z]")
	var re_match := word_re.search(character)
	return re_match != null

func is_lower(character: String) -> bool:
	var word_re := RegEx.new()
	word_re.compile("[a-z]")
	var re_match := word_re.search(character)
	return re_match != null

func is_space(character: String) -> bool:
	return not character.is_empty() and character.strip_edges() == "" 

func _compute_speed_index(a76:int, a7a:int, coart:int) -> int:
	"""Return speed_index = clamp(a76 + a7a + idiv(2*coart, 19), 0, 9)."""
	var a7e = idiv_trunc(2 * coart, 19)
	return max(0, min(9, a76 + a7a + a7e))

func parse_phonemes(phon_str: String, a76=DEFAULT_A76):
	"""
	Walk G2P output string and return [(phoneme_idx, speed_index), ...].

	Prosody state is tracked inline:
		coart     — [0xb8a], init 0; updated by \\ (+10) and / (-10)
		sec_pitch — [0xa7c], init 0; set to ±5 by [ and ]; consumed at each phoneme
	speed_index is frozen for each phoneme at the moment it is emitted.
	a76 is the per-phoneme base pitch index; pass A76_BY_PITCH[pitch_level] to
	shift the overall pitch.
	"""
	var coart := 0
	var sec_pitch := 0

	var result = []
	var i := 0
	while i < len(phon_str):
		var ch := phon_str[i]

		if ch == '\\':
			coart = min(70, coart + 10)
			i += 1
			continue
		if ch == '/':
			coart = max(-50, coart - 10)
			i += 1
			continue
		if ch == '[':
			sec_pitch = 5
			i += 1
			continue
		if ch == ']':
			sec_pitch = -5
			i += 1
			continue
		if ch == 'j':
			i += 1
			continue

		var phoneme_idx = null
		if is_upper(ch) and i + 1 < len(phon_str) and is_upper(phon_str[i + 1]):
			var name := phon_str.substr(i, i + 2) #[i:i + 2]
			phoneme_idx = PHON_IDX.get(name)
			if phoneme_idx == null:
				printerr('  [warn] unknown 2-char phoneme: %s' % name)
			i += 2
		elif is_lower(ch):
			phoneme_idx = CONS_IDX.get(ch)
			if phoneme_idx == null:
				printerr('  [warn] unknown consonant: %s' % ch)
			i += 1
		else:
			i += 1
			continue

		if phoneme_idx == null:
			sec_pitch = 0
			continue

		var a7a := sec_pitch
		sec_pitch = 0
		var speed_idx := _compute_speed_index(a76, a7a, coart)
		result.append([phoneme_idx, speed_idx])

	return result

# ── Binary synthesis string parsing ──────────────────────────────────────────

func parse_synth_binary(raw_bytes: PackedInt32Array, pitch_level: int) -> Array:
	"""
	Walk the binary synthesis string from DS:0x0860 and return
	[(phoneme_idx, b8a, a7a), ...] including the leading and trailing SIL bytes.

	b8a persists across phonemes until explicitly changed by a modifier byte:
		bytes 46–55: b8a = (byte - 45 - pitch_level) * 10  (Converter pitch-class, absolute set)
			If immediately followed by another byte in [46,55], that byte adjusts:
			b8a += next_byte - 55  (two-byte form, both consumed).
		byte 57 ('\\'):  b8a = min(70, b8a + 10)             (cumulative increase)
		byte 56 ('/'):  b8a = max(-50, b8a - 10)            (cumulative decrease)

	a7a (sec_pitch) is consumed once per phoneme from the a7c accumulator.
	Bytes 44/45 handler (CS:0x03C2): two-byte form when nxt in [46,55].
		x86 computes: bl = nxt-55; ja (nxt>55) or jng (nxt≤45) → single-byte.
		Fall-through only when nxt in [46,55]: consume nxt, a7c = 55-nxt (byte 44)
		or nxt-55 (byte 45).  Single-byte: a7c = ±5.
	At each phoneme boundary: a7a = a7c; a7c = 0.
	"""
	var b8a := 0
	var a7c := 0
	var result:Array = []
	var i := 0
	while i < len(raw_bytes):
		var byte = raw_bytes[i]
		if byte < 44:                       # phoneme index 0–43
			result.append([byte, b8a, a7c])
			a7c = 0
			i += 1
		elif byte == 44 or byte == 45:      # a7c sequence (CS:0x03C2)
			var nxt := raw_bytes[i + 1] if i + 1 < len(raw_bytes) else 0
			if 46 <= nxt and nxt <= 55:             # two-byte form: consume nxt
				a7c = (55 - nxt) if byte == 44 else (nxt - 55)
				i += 2
			else:
				a7c = 5 if byte == 44 else -5
				i += 1
		elif 46 <= byte and byte <= 55:              # pitch-class absolute set (CS:0x03EF)
			b8a = (byte - 45 - pitch_level) * 10
			var nxt := raw_bytes[i + 1] if i + 1 < len(raw_bytes) else 0
			if 46 <= nxt and nxt <= 55:             # two-byte form: consume adjustment byte
				b8a += nxt - 55
				i += 2
			else:
				i += 1
		elif byte == 57:                    # '\' cumulative +10
			b8a = min(70, b8a + 10)
			i += 1
		elif byte == 56:                    # '/' cumulative -10
			b8a = max(-50, b8a - 10)
			i += 1
		else:
			i += 1
	return result

# ── Segment chain playback ────────────────────────────────────────────────────

func play_chain(ptr, reverse, out):
	"""
	Append samples from a segment list chain (is_voiced=True / unvoiced path).
	Each block contributes exactly e['period_len'] output samples.
	"""
	if ptr == null:
		return
	var entries: Array = SL.get(str(ptr))
	if not entries:
		return
	if reverse:
		entries.reverse()

	for e in entries:
		var samples := blocks[e['block_idx']]
		if not samples:
			continue
		#out.extend(samples[:e['period_len']])
		for s in samples.slice(0, e['period_len']):
			out.append_array(s)


func play_chain_blocks(ptr:int, t_rev:bool, out:Samples, b88:int, b89:int, a80:int, speed_idx: int, block_emissions=null, block_states=null) -> Array:
	"""
	Unified chain player: each block is dispatched individually based on its own
	is_voiced flag (b8d), not the chain's first block.

	is_voiced=False (b8d=0): voiced path CS:0x07CA — b88 pitch-interp step,
		zero-fill, PCM output, a80 decrement each period.
	is_voiced=True (b8d=1): unvoiced path CS:0x07CD — b87/b86 ramp.
		b94=t_rev: if True (SIL-adjacent), a80 decrements; if False, no decrement.

	Block iteration order: reversed only when t_rev=True AND the chain is purely
	voiced (all is_voiced=False); unvoiced and mixed chains always play forward.

	CS:0x071B DI rules (DI = speed_idx × 2) apply to both paths:
		DI < 10: inc a82 → extra outer-loop iteration (extra PCM per depletion).
		DI > 10: dec a82 → if 0: break (skip PCM, exit block).
		DI == 10: no change.

	Returns (new_b88, new_a80).
	"""
	if ptr == null:
		return [b88, a80]
	var entries: Array = SL.get(str(ptr)) if SL.has(str(ptr)) else []
	if entries.is_empty():
		return [b88, a80]

	var all_unvoiced := false
	for e in entries:
		if not e['is_voiced']:
			all_unvoiced = true
			break

	if t_rev and all_unvoiced:
		entries.reverse()

	var di := speed_idx * 2

	for e in entries:
		var period_len: int = e['period_len']
		var a82 := 1   # CC28 resets a82=1 at each block entry
		var block_start := len(out.samples)

		if block_states != null:
			# Snapshot per-block state at the equivalent of CS:0x070A (after CC28
			# reset, before per-period inner loop). Mirrors the field set in
			# trace_blocks.py:103-120 and the new dsstub.asm header layout.
			block_states.append({
				'a80': a80,
				'a82': a82,
				'b88': b88,
				'b89': b89,
				'b8a': b89,                       # phoneme param source = our b89 input
				'b8d': 1 if e['is_voiced'] else 0,
				'b94': 1 if t_rev else 0,
				'b86': 0,                         # residual; not tracked in Python state
				'period_len': period_len,
			})

		if not e['is_voiced']:
			# Voiced path (CS:0x07CA): b88 step + period-extension pad + PCM + a80
			while a82 > 0:
				var diff := b89 - b88
				var step := 0
				if diff > 0:
					step = (diff >> 4) + 1
				elif diff < 0:
					step = diff >> 4

				b88 += step

				var b86: int
				if b88 > 0:
					# Period-extension pad for F0 lowering (patent US 4,692,941).
					# The original DAC HOLDS its last written value during this
					# period extension — it does NOT rewrite zero. Writing zero
					# introduces large discontinuities (audible hiss) at every
					# period boundary; holding the last value matches the
					# captured DOSBox waveform exactly (samples 27800-27830 of
					# exports/human_full vs data/dosbox_ground_truth.wav).
					var last_val = out.samples[-1] if not out.samples.is_empty() else 0
					for _i in b88:
						out.samples.append(last_val)
					b86 = period_len
				else:
					b86 = (period_len + b88) if period_len >= 75 else period_len
					b86 = max(0, b86)

				a80 -= 16
				if a80 <= 0:
					a80 += SPEED_TABLE[speed_idx]
					if di > 10:
						a82 -= 1
						if a82 == 0:
							break
					elif di < 10:
						a82 += 1

				if b86 > 0:
					var samples := blocks[e['block_idx']]
					if samples:
						out.samples.append_array(samples.slice(0, b86))

				a82 -= 1

		else:
			# Unvoiced path (CS:0x07CD): b87/b86 ramp; a80 only if b94=t_rev=True
			var b87 := period_len >> 3
			var b86 := period_len + b87

			while a82 > 0:
				b86 -= b87
				if b86 < b87:
					b86 = b87

				if t_rev:   # b94=1: always decrement a80
					a80 -= 16
					if a80 <= 0:
						a80 += SPEED_TABLE[speed_idx]
						if di > 10:
							a82 -= 1
							if a82 == 0:
								break
						elif di < 10:
							a82 += 1
				# b94=0: skip decrement, no a80 change

				if b86 > 0:
					var samples := blocks[e['block_idx']]
					if samples:
						out.samples.append_array(samples.slice(0, b86))

				a82 -= 1

		if block_emissions != null:
			block_emissions.append(len(out.samples) - block_start)

	return [b88, a80]

# ── Punctuation → silence ─────────────────────────────────────────────────────

const PUNCT_SILS := {',': 2, ';': 2, '.': 4, '!': 4, '?': 4}

# Split text on punctuation. Returns Array of [clause_text: String, n_sil_after: int].
func split_clauses(text: String) -> Array:
	var clauses: Array = []
	var chunk := ""
	var i := 0
	var n := text.length()
											
	while i < n:
		var ch: String = text[i]
		if PUNCT_SILS.has(ch):
			# Collect run of consecutive punctuation chars; take max silence.
			var n_sil := 0
			while i < n and PUNCT_SILS.has(text[i]):
				n_sil = max(n_sil, PUNCT_SILS[text[i]])
				i += 1
			var stripped := chunk.strip_edges()
			if stripped != "":
				clauses.append([stripped, n_sil])
			elif not clauses.is_empty() and n_sil > 0:
				# Empty chunk between two punctuation runs — merge silences.                                                                                                                                                               
				var prev: Array = clauses[-1]
				clauses[-1] = [prev[0], max(prev[1], n_sil)]
			chunk = ""
		else:
			chunk += ch
			i += 1

	# Trailing chunk after last punctuation (or text with no punctuation at all).                                                                                                                                                          
	var tail := chunk.strip_edges()
	if tail != "":
		clauses.append([tail, 0])
	return clauses

# ── Main synthesis ────────────────────────────────────────────────────────────

const SIL = [0, 0]   # (phoneme_idx, b8a) — SIL always with b8a=0


func _speed_idx(b8a:int, pitch_level:int, a7a:=0) -> int:
	"""Return speed_idx = clamp(pitch_level + a7a + int(2*b8a/19), 0, 9)."""
	var a7e := int(2 * b8a / 19)   # x86 IDIV truncation toward zero (same as int())
	return max(0, min(9, pitch_level + a7a + a7e))


func _python_get_synth_binary(text: String, pitch_level=5) -> PackedInt32Array:
	"""Pure-Python alternative to unicorn_render.get_synth_binary.

	Pipeline: g2p_engine.g2p_sentence → prosody.insert_digit_prosody
	→ python_converter.convert. **Single pass** — SBTalker's own G2P calls
	the digit-prosody function exactly once per Say invocation regardless of
	interior periods/commas (verified from `LOGCPU_HUMAN_FULL.TXT`). The
	g2p_engine handles commas as 2-space SIL markers and drops interior
	periods, mirroring SBTalker's display-string output.

	Mirrors SBTalker's auto-append of `.` if user input has no terminal punct.
	"""

	var text_norm := text.strip_edges(false, true)
	if text_norm and text_norm[-1] not in '!.;?':
		text_norm += '.'
	# TODO: make static functions
	var g2p_engine := TTS079G2PEngine.new()
	var prosody_engine := TTS079Prosody.new()
	var g2p := g2p_engine.g2p_sentence(text_norm)
	var display := prosody_engine.insert_digit_prosody(' ' + g2p)
	var body := convert_phoneme_to_binary(display, pitch_level)
	# parse_synth_binary expects a leading SIL (the unicorn path includes it
	# since DS:0x0860 has a length byte that becomes 0; here we mirror that).
	# Trailing SIL post-amble: SBTalker's synth processor doesn't stop at
	# the explicit terminator — it continues reading SIL bytes from the
	# zero-initialised buffer and emits ~9 SIL→SIL pairs before its stop
	# condition fires (likely a DMA-buffer-drain counter; see docs/synth_notes.md).
	# Each appended SIL byte produces 8 trailing blocks. Verified against all
	# 8 captured WAVEOUTs: 10 trailing SILs reproduce DOSBox's tail to within
	# one final emit=0 block (zero audio impact, ±1 block-count delta).
	const TRAILING_SILS = 10
	var trailing := PackedInt32Array()                                                                                                                                                                                                          
	trailing.resize(TRAILING_SILS) # new bytes are zero-initialized                                                                                                                                                                     
	return PackedInt32Array([0]) + body + trailing 


func synthesise(text:String, pitch_level=5) -> PackedByteArray:
	"""
	Return an int16 numpy array of PCM samples at SAMPLE_RATE Hz.

	pitch_level (0–9) mirrors the SBTALKER pitch parameter:
		0 = lowest pitch (~44 Hz F0), 5 = normal (~91 Hz), 9 = highest (~158 Hz).

	`engine`:
		'python'  — fully standalone Python pipeline (g2p_engine + prosody +
			python_converter), no DOSBox/Unicorn dependency.
		'unicorn' — legacy path: SBTalker Converter via Unicorn. Kept for A/B.

	The synthesis loop (parse_synth_binary + play_chain_blocks) is identical
	in both cases — only the binary-stream source differs.
	"""
	
	var raw := _python_get_synth_binary(text, pitch_level)
	var seq := parse_synth_binary(raw, pitch_level)   # [(phoneme_idx, b8a), ...]

	var samples := Samples.new()
	var last := len(seq) - 2   # index of last pair before terminal SIL

	# Per-pair running state (threads across T2→T1 boundaries)
	var b88 := 0
	var a80 := SPEED_TABLE[5]   # SENTINEL default; first voiced T2 resets this

	for i in range(len(seq) - 1):
		#prev_idx, prev_b8a, prev_a7a = seq[i]
		#curr_idx, curr_b8a, curr_a7a = seq[i + 1]
		var prev: Array = seq[i]
		var prev_idx:int = prev[0]
		var prev_b8a:int = prev[1]
		var prev_a7a:int = prev[2]
		var curr: Array = seq[i + 1]
		var curr_idx:int = curr[0]
		var curr_b8a:int = curr[1]
		var curr_a7a:int = curr[2]
		var key   = "%d,%d" % [prev_idx,curr_idx]
		var entry := TT.get(key)
		if entry == null:
			continue

		# T1: uses b89=b8a of PREVIOUS phoneme, inherits b88/a80 from prev T2
		if i > 0 and entry['t1'] != null:
			# b88, a80
			var res = play_chain_blocks(
				entry['t1'], entry['t1_rev'], samples,
				b88, prev_b8a, a80, _speed_idx(prev_b8a, pitch_level, prev_a7a))
			b88 = res[0]
			a80 = res[1]

		# T2: always reset a80 for current phoneme; b89 = curr_b8a
		if i < last and entry['t2'] != null:
			var si := _speed_idx(curr_b8a, pitch_level, curr_a7a)
			a80 = SPEED_TABLE[si]
			# b88, a80
			var res = play_chain_blocks(
				entry['t2'], entry['t2_rev'], samples,
				b88, curr_b8a, a80, si)
			b88 = res[0]
			a80 = res[1]

	#arr = np.asarray(samples, dtype=np.int16)
	return samples.samples





r"""
SBTalker Converter port — display-format string → binary synthesis bytes.

Reverse-engineered from CS:0x1483:0x01B3-0x02F2 in SBTALKER.EXE. Maps each
character of the (digit-prosody-processed) display string to the binary
synthesis byte the phoneme dispatch loop at CS:0x039F consumes.

Reference: docs/g2p_phoneme_format.md §4.4, §5.

API
---
	convert(display: str, pitch_idx: int = 4) -> bytes

`pitch_idx` is unused at this layer (pitch is encoded in the digit-prosody
markers, not in the binary output) but accepted for forward-compatibility.

Byte semantics in the output (consumed by parse_synth_binary):

| Byte | Meaning |
|---|---|
| 0    | SIL (silence / word boundary / terminator) |
| 1–43 | Phoneme index (per §5.3 / §5.4 mappings) |
| 44   | `[` — secondary stress up (sets a7c = +5) |
| 45   | `]` — secondary stress down (sets a7c = -5) |
| 46–55 | Pitch class — digit '9'→46 (b8a -40) … '0'→55 (b8a +50) |
| 56   | `/` — cumulative pitch down (b8a -= 10, clamped at -50) |
| 57   | `\` — cumulative pitch up (b8a += 10, clamped at +70) |

After all chars are consumed, a SIL terminator (0) is appended.
"""

# Two-char phoneme name → synthesis index.
# Source: docs/g2p_phoneme_format.md §5.3 (verified against captured streams).
const DIGRAPHS := {
	'AA': 7,  'AH': 5,  'AX': 6,  'AY': 37,
	'AE': 4,  'EH': 3,  'AW': 42, 'EY': 38,
	'AO': 10, 'DH': 26, 'DX': 15, 'OY': 41,
	'ZH': 28, 'UH': 8,  'OW': 9,  'IH': 1,
	'IX': 2,  'IY': 39, 'UW': 40, 'TH': 22,
	'TX': 14, 'SH': 24, 'KX': 17, 'PX': 12,
	'ER': 43, 'NG': 32,
}

# Single-letter (lowercase) consonant → synthesis index.
# Read directly from CS_SYNTH:0x010A in MEMDUMP_SBTALKER_ONLY.BIN (phys 0x1493A).
# Indexed by `letter - 0x60` (so 'a'=1, 'b'=2, …, 'z'=26).
# Entries marked 0xFF in the table are *not* in this dict — those letters
# (a, c, e, i, j, o, q, u, x) are handled by the uppercase digraph matcher
# or are silently skipped. The docs §5.4 note that v/y/w/z were "handled by
# other means" was incorrect — they have valid table entries.
const LOWERCASE := {
	'b': 18,  # BND
	'd': 19,  # D
	'f': 21,  # F
	'g': 20,  # G
	'h': 34,  # HH
	'k': 16,  # K
	'l': 29,  # L
	'm': 30,  # M
	'n': 31,  # N
	'p': 11,  # B_P
	'r': 35,  # R
	's': 23,  # S
	't': 13,  # T_B
	'v': 25,  # V
	'w': 36,  # W
	'y': 33,  # Y
	'z': 27,  # Z
}

# Single-byte prosody markers / specials.
const SPECIALS := {
	'[': 44,
	']': 45,
	'\\': 57,
	'/': 56,
}

# Digit chars '0'..'9' → pitch-class bytes 55..46 (descending).
# Per CS:0xAA table at offset 0x30..0x39: bytes 0x37, 0x36, ..., 0x2E.
const DIGITS := {'0': 55, '1': 54, '2': 53, '3': 52, '4': 51, '5': 50, '6': 49, '7': 48, '8': 47, '9': 46}


func convert_phoneme_to_binary(display: String, pitch_idx:=4) -> PackedInt32Array:
	"""Convert a display-format phoneme string to the binary synthesis stream.

	Skips:
		- any leading separator byte (Pascal-length convention; first char
			is treated as throwaway if it's whitespace or a control byte)
		- whitespace within the string (mapped to SIL byte 0)
		- terminal punctuation '!.;?' (treated as end-of-string)

	Unknown characters are skipped silently. Add them to the appropriate
	table above if they're hit during validation.
	"""
	var out: PackedInt32Array = []
	var i := 0
	# Skip a single leading space sentinel if present (matches the prefix our
	# prosody.insert_digit_prosody output uses).
	if i < len(display) and display[i] == ' ':
		i += 1
	while i < len(display):
		var c := display[i]
		# End at terminal punctuation
		if c in '!.;?':
			break
		# SIL on whitespace
		if is_space(c):
			out.append(0)
			i += 1
			continue
		# Digit prosody marker
		if c in DIGITS:
			out.append(DIGITS[c])
			i += 1
			continue
		# Single-byte special markers
		if c in SPECIALS:
			out.append(SPECIALS[c])
			i += 1
			continue
		# Lowercase consonant lookup
		if c in LOWERCASE:
			out.append(LOWERCASE[c])
			i += 1
			continue
		# Two-char digraph (uppercase ASCII letter)
		if is_upper(c) and i + 1 < len(display):
			var digraph := c + display[i + 1]
			if digraph in DIGRAPHS:
				out.append(DIGRAPHS[digraph])
				i += 2
				continue
		# Unknown char — skip
		i += 1
	# Append SIL terminator
	out.append(0)
	return out

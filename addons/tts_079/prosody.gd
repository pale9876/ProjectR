class_name TTS079Prosody

r"""
SBTalker digit-prosody insertion (port of CS:0x935:0D7F).

This module mirrors the static-code function in SBTALKER.EXE that adds ASCII
digit chars '0'..'9' to a display-format phoneme string before the Converter
runs. Each digit selects an absolute pitch class (digit '0' → highest pitch,
'9' → lowest) — the pattern produces the descending phrase-final melody you
hear in DOSBox output.

Algorithm reference: docs/g2p_phoneme_format.md §4.3.

API
---
    insert_digit_prosody(display: str) -> str

Input format: marker-bearing display string from the upstream G2P stage.
Position 0 is treated as a leading separator (Pascal-style length byte
equivalent) and never a vowel. The function processes positions 1..end and:

  - counts vowel-starting chars in {A,E,I,O,U} (skipping the next char to
    handle 2-letter phoneme names like AE, IH, OW), giving N
  - identifies the first terminal-punct char {!,.,;,?} as `term`
  - builds array[1..N] = 7 - ((N//2 + 4*i) // N)
  - mutates array based on `term`
  - re-scans, processing markers # @ / \ as state changes (deleted from
    output) and emitting chr('0' + clamp(array[di] + delta, 0, 9)) before
    each vowel char (skipping di=1 and de-duping vs previous emission)

If the input contains no terminal punctuation the array is built but never
mutated by the punct branch (default case).

Empty / vowel-free strings pass through unchanged.
"""

const VOWEL_STARTS = ['A','E','I','O','U']
const TERM_PUNCT = ['!','.',';','?']


func _count_vowels_and_terminal(s: String) -> Array:
	"""Pass 1: count vowel-starts and find terminal punct."""
	var N := 0
	var term := ''
	var i = 1
	while i < len(s):
		var c := s[i]
		if c in VOWEL_STARTS:
			N += 1
			i += 1   # skip 2nd char of phoneme name
		if i < len(s) and s[i] in TERM_PUNCT:
			term = s[i]
			break
		i += 1
	return [min(N, 100), term]


func _build_array(N, term: String) -> Array:
	"""Phases 2 + 3: build array[1..N], apply punct mutation."""
	if N < 1:
		return []
	var array: Array = [null]
	for i in range(1, N + 1):
		array.append(7 - ((N / 2 + 4 * i) / N))
	if term == '.':
		if N >= 1: array[N]     = 0
		if N >= 2: array[N - 1] = 1
		if N >= 3: array[N - 2] = 2
	elif term == ';':
		if N >= 1: array[N] = 2
	elif term == '?':
		if N >= 1: array[N]     = 9
		if N >= 2: array[N - 1] = 7
	elif term == '!':
		for i in range(1, N + 1):
			if array[i] < 8:
				array[i] += 2
		if N >= 1: array[N]     = 9
		if N >= 2: array[N - 1] = 8
		array[1] = 9
	return array


func insert_digit_prosody(display:String) -> String:
	"""Insert digit prosody markers and strip /\\#@ markers from `display`."""
	#N, term
	var count := _count_vowels_and_terminal(display)
	var N: int = count[0]
	var term:String = count[1]
	var array := _build_array(N, term)
	if array.is_empty():
		return display

	var out := [] if display.is_empty() else [display.substr(0, 1)] #list(display[:1])
	var di := 0
	# SBTalker initializes the previous-emit slot [bp-0x12] = 5 at the start
	# of pass 2 (CS:0x935:0D9A). The dedup check at CS:0x935:0C7B then
	# compares the new value against this; an initial emit of 5 is suppressed.
	var last_emitted := 5
	var delta := 0
	var stress := 0
	var i := 1
	while i < len(display):
		var c := display[i]
		if c == '#':
			stress += 1
			i += 1
			continue
		if c == '@':
			if stress > 0:
				stress -= 1
			i += 1
			continue
		if c == '/':
			delta += 1
			i += 1
			continue
		if c == '\\':
			delta -= 1
			i += 1
			continue
		if c in VOWEL_STARTS:
			di += 1
			if 1 < di and di <= N and stress == 0:
				var v := max(0, min(9, array[di] + delta))
				if v != last_emitted:
					out.append(char("0".unicode_at(0) + v))
					last_emitted = v
			out.append(c)
			i += 1
			if i < len(display):
				out.append(display[i])
			i += 1
		else:
			out.append(c)
			i += 1
	return ''.join(out)

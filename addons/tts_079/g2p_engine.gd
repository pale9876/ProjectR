class_name TTS079G2PEngine

const VOWELS:PackedStringArray = ['A','E','I','O','U','Y'] # CONS_VOWELS
const FRONT_VOWELS:PackedStringArray = ['E','I','Y']
const VOICED_CONS:PackedStringArray = ['B','D','J','G','L','M','N','R','V','W','Z']
const AT_CLASS:PackedStringArray = ['D','J','L','N','R','S','T','W','Z']

var RULES: Dictionary

class BoolInt:
	var b: bool
	var i: int
	func _init(bb: bool, ii: int) -> void:
		b = bb
		i = ii
	func _to_string() -> String:
		return "%s %s" % [b, i]

func _init() -> void:
	var file = FileAccess.open("res://addons/tts_079/data/g2p_rules.json", FileAccess.READ)
	RULES = JSON.parse_string(file.get_as_text())

func is_vowel(character: String) -> bool:
	return character in VOWELS or character == 'x00'

func is_alphabetic(character: String) -> bool:
	assert(character.length() == 1)
	var word_re := RegEx.new()
	word_re.compile("[A-Z]")
	var re_match := word_re.search(character)
	return re_match != null

func is_consonant(character: String) -> bool:
	return is_alphabetic(character) and character not in VOWELS

func match_rctx(word: String, pos: int, pattern: String) -> BoolInt:
	var i := pos
	for ch in pattern:
		if i >= len(word):
			BoolInt.new(false, pos)
		if ch == "'" or ch == '.':
			if word[i] != ch:
				return BoolInt.new(false, pos)
		elif is_alphabetic(ch):
			if word[i] != ch:
				return BoolInt.new(false, pos)
		else:
			return BoolInt.new(false, pos)
		i += 1
	return BoolInt.new(true, i)

func _match_suffix_percent(word: String, pos: int) -> BoolInt:
	for suf in ['ERS', 'ELY', 'ING', 'ER', 'ED', 'ES', 'E']:
		var end := pos + len(suf)
		if word.substr(pos, end) == suf and (end >= len(word) or word[end] in [' ', 'x00']):
			return BoolInt.new(true, end)
	return BoolInt.new(false, pos)

func _match_suffix_bang(word: String, pos: int) -> BoolInt:
	if pos >= len(word) or not is_alphabetic(word[pos]):
		return BoolInt.new(true, pos)  # end-of-word (any non-letter)
	var ch := word[pos] if pos < len(word) else ''
	var nx := word[pos+1] if pos+1 < len(word) else ''
	# Word-final S (S at word boundary)
	if ch == 'S' and (not is_alphabetic(nx)):
		return BoolInt.new(true, pos + 1)
	# LY suffix
	if ch == 'L' and nx == 'Y' and (pos+2 >= len(word) or not is_alphabetic(word[pos+2])):
		return BoolInt.new(true, pos + 2)
	# MENT suffix
	if word.substr(pos, pos+4) == 'MENT' and (pos+4 >= len(word) or not is_alphabetic(word[pos+4])):
		return BoolInt.new(true, pos + 4)
	# NESS suffix
	if word.substr(pos, pos+4) == 'NESS' and (pos+4 >= len(word) or not is_alphabetic(word[pos+4])):
		return BoolInt.new(true, pos + 4)
	return BoolInt.new(false, pos)

func _match_suffix_dash(word: String, pos: int) -> BoolInt:
	var ch := word[pos] if pos < len(word) else ''
	var nx := word[pos+1] if pos+1 < len(word) else ''
	if ch == 'Y' and not is_alphabetic(nx):
		return BoolInt.new(true, pos + 1)
	if ch == 'I' and nx == 'E' and (pos+2 >= len(word) or not is_alphabetic(word[pos+2])):
		return BoolInt.new(true, pos + 2)
	return BoolInt.new(false, pos)

func match_bctx(word: String, pos: int, pattern: String) -> bool:
	var i := pos
	var p := 0
	while p < len(pattern):
		var ch := pattern[p]
		var wch := word[i] if i < len(word) else 'x00'

		if ch == '#':
			if not is_vowel(wch):
				return false
			i += 1
			while i < len(word) and is_vowel(word[i]):
				i += 1
		elif ch == '^':
			if wch == 'Q' and i+1 < len(word) and word[i+1] == 'U':
				i += 2
			elif is_consonant(wch):
				i += 1
			else:
				return false
		elif ch == '*':
			if not is_consonant(wch) and not (wch == 'Q' and i+1 < len(word) and word[i+1] == 'U'):
				return false
			if wch == 'Q' and i+1 < len(word) and word[i+1] == 'U':
				i += 2
			else:
				i += 1
			while i < len(word) and is_consonant(word[i]):
				i += 1
		elif ch == ':':
			while i < len(word) and is_consonant(word[i]):
				i += 1
		elif ch == '+':
			if wch not in FRONT_VOWELS:
				return false
			i += 1
		elif ch == '.':
			if wch not in VOICED_CONS:
				return false
			i += 1
		elif ch == '%':
			var oki := _match_suffix_percent(word, i)
			if not oki.b:
				return false
		elif ch == '!':
			var oki := _match_suffix_bang(word, i)
			if not oki.b:
				return false
		elif ch == '-':
			var oki := _match_suffix_dash(word, i)
			if not oki.b:
				return false
		elif ch == ' ':
			if wch != ' ':
				return false
			i += 1
		elif ch == "'":
			if wch != "'":
				return false
			i += 1
		elif is_alphabetic(ch):
			if wch != ch:
				return false
			i += 1
		else:
			return false  # unknown
		p += 1
	return true

func match_lctx(word: String, pos: int, pattern: String) -> bool:
	"""
	Match L-ctx pattern against word going backward from pos-1.
	pattern[0] is checked against word[pos-1], pattern[1] against word[pos-2], etc.
	Return True/False.
	"""
	var i := pos - 1  # start just left of current letter

	for ch in pattern:
		var wch := word[i] if 0 <= i and i < len(word) else 'x00'

		if ch == '#':
			if not is_vowel(wch):
				return false
			i -= 1
			while i >= 0 and is_vowel(word[i]):
				i -= 1
		elif ch == '^':
			if not is_consonant(wch):
				return false
			i -= 1
		elif ch == '*':
			if not is_consonant(wch):
				# Allow QU: going backward, current=U next(left)=Q
				if wch == 'U' and i-1 >= 0 and word[i-1] == 'Q':
					i -= 2
				else:
					return false
			else:
				i -= 1
				while i >= 0 and is_consonant(word[i]):
					i -= 1
		elif ch == ':':
			while i >= 0 and is_consonant(word[i]):
				i -= 1
		elif ch == '+':
			if wch not in FRONT_VOWELS:
				return false
			i -= 1
		elif ch == '.':
			if wch not in VOICED_CONS:
				return false
			i -= 1
		elif ch == '@':
			# Two paths: CH/SH/TH digraph, OR type bit-2 class (D,J,L,N,R,S,T,W,Z)
			if wch == 'H':
				var prev := word[i-1] if i-1 >= 0 else 'x00'
				if prev not in ['C', 'S', 'T']:
					return false
				i -= 2
			elif wch in AT_CLASS:
				i -= 1
			else:
				return false
		elif ch == '&':
			# Sibilant: SH or CH digraph, or S/Z
			if wch == 'H' and i-1 >= 0 and word[i-1] in ['C', 'S']:
				i -= 2
			elif wch in ['S', 'Z']:
				i -= 1
			else:
				return false
		elif ch == ' ':
			if wch != ' ':
				return false
			i -= 1
		elif ch == "'":
			if wch != "'":
				return false
			i -= 1
		elif ch == '.':
			if wch != '.':
				return false
			i -= 1
		elif is_alphabetic(ch):
			if wch != ch:
				return false
			i -= 1
		else:
			return false
	return true


func g2p_word(word_with_spaces: String):
	"""
	word_with_spaces: uppercase string like ' HELLO ' with leading+trailing space.
	Returns phoneme string.
	"""
	var word := word_with_spaces
	var result := []
	var i := 1  # skip leading space

	while i < len(word):
		var ch := word[i]
		if ch == ' ':
			break
		if ch == "'" or ch == '.':
			i += 1
			continue
		if not is_alphabetic(ch):
			i += 1
			continue

		var letter_rules := RULES.get(ch, [])
		var phoneme := ''
		var advance := 1

		for rule in letter_rules:
			var rctx := match_rctx(word, i + 1, rule['rctx'])
			if not rctx.b:
				continue
			if not match_lctx(word, i, rule['lctx']):
				continue
			if not match_bctx(word, rctx.i, rule['bctx']):
				continue
			phoneme = rule['phon']
			advance = rctx.i - i  # chars consumed = 1 (current) + len(rctx)
			break

		result.append(phoneme)
		i += advance

	return ''.join(result)


func preprocess(sentence: String) -> Array:
	"""Uppercase, keep letters/apostrophe/comma/spaces, split into words.

	Interior periods are stripped here because SBTalker's G2P scans them
	as transparent (per docs §6: "scan until space after ' or ."). Keeping
	them would cause rule B-contexts that expect ' ' (space) to fail when
	followed by a period, e.g. word-final Y in "carefully." would fall
	through to the catch-all IH instead of matching `L='*#', B=' '` → IY.
	The terminal `.` from the original sentence is re-appended in
	g2p_sentence after rule matching completes.
	"""
	var upper := sentence.to_upper()
	# Drop interior periods entirely (terminal punct is re-added later)
	upper = upper.replace('.', '')
	var clean_re := RegEx.new()                                                                                                                                                                                                            
	clean_re.compile("[^A-Z', ]")
	var cleaned := clean_re.sub(upper, '', true)
	
	var word_re := RegEx.new()
	word_re.compile("[A-Z,]")
	var res: PackedStringArray = []
	for w in cleaned.split(" ", false):
		if word_re.search(w) != null:
			res.append(w)
	return res


func g2p_sentence(sentence: String) -> String:
	"""Process full sentence in one pass so B-ctx crosses word boundaries correctly.

	Output format mirrors what SBTalker's own G2P writes to the display-string
	buffer (verified against `data/LOGCPU_HUMAN_FULL.TXT`):
		- inter-word spaces are dropped (words concatenate)
		- apostrophes and INTERIOR periods are dropped
		- commas become TWO ASCII space chars, which the Converter maps to two
			SIL bytes (audible inter-clause pause)
		- terminal `.`/`!`/`?`/`;` is preserved at end of output (drives the
			digit-prosody pass's terminal-mutation branch)
	"""
	var words := preprocess(sentence)
	var full := ' ' + ' '.join(words) + ' '
	var result := []
	var i := 1  # skip leading space
	while i < len(full):
		var ch := full[i]
		if ch == ' ':
			i += 1
			continue
		if ch == "'" or ch == '.':
			i += 1
			continue
		if ch == ',':
			# Comma → two spaces. Mirrors SBTalker's display-string output
			# (one ASCII 0x20 from the comma itself, plus the trailing input
			# space that's also passed through). Each space becomes a SIL
			# byte 0 in the binary stream.
			result.append('  ')
			i += 1
			continue
		if not is_alphabetic(ch):
			i += 1
			continue

		var letter_rules := RULES.get(ch, [])
		var phoneme := ''
		var advance := 1

		for rule in letter_rules:
			var rctx := match_rctx(full, i + 1, rule['rctx'])
			if not rctx.b:
				continue
			if not match_lctx(full, i, rule['lctx']):
				continue
			if not match_bctx(full, rctx.i, rule['bctx']):
				continue
			phoneme = rule['phon']
			advance = rctx.i - i
			break

		result.append(phoneme)
		i += advance

	# Preserve terminal punctuation from the original (un-cleaned) sentence so
	# the digit-prosody pass can detect the intonation contour. Strip trailing
	# whitespace; if the last non-space char is one of {!,.,;,?}, append it.
	var s := sentence.strip_edges(false, true)
	if s and s[-1] in '!.;?':
		result.append(s[-1])

	return ''.join(result)

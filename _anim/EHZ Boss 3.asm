; animation script
; off_2FAC8:
Ani_obj56_c:	offsetTable
		offsetTableEntry.w byte_2FAD2	; 0
		offsetTableEntry.w byte_2FAD5	; 1
		offsetTableEntry.w byte_2FAD9	; 2
		offsetTableEntry.w byte_2FAE2	; 3
		offsetTableEntry.w byte_2FAEB	; 4
byte_2FAD2:	dc.b  $F,  0,$FF	; bottom
	rev02even
byte_2FAD5:	dc.b   7,  1,  2,$FF	; top, normal
	rev02even
byte_2FAD9:	dc.b   7,  5,  5,  5,  5,  5,  5,$FD,  1	; top, when hit
	rev02even
byte_2FAE2:	dc.b   7,  3,  4,  3,  4,  3,  4,$FD,  1	; top, laughter (when hurting Sonic)
	rev02even
byte_2FAEB:	dc.b  $F,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,$FD,  1	; top, when flying off
	even	; for top part, after end of special animations always return to normal one ($FD->1)

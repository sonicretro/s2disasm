; animation script
; off_2FA44:
Ani_obj56_b:	offsetTable
		offsetTableEntry.w byte_2FA4A	; 0
		offsetTableEntry.w byte_2FA4F	; 1
		offsetTableEntry.w byte_2FA53	; 2
byte_2FA4A:
	dc.b   5,  1,  2,  3,$FF	; spike
	rev02even
byte_2FA4F:
	dc.b   1,  4,  5,$FF	; foreground wheel
	rev02even
byte_2FA53:
	dc.b   1,  6,  7,$FF	; background wheel
	even

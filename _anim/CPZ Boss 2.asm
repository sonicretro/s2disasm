; animation script
; off_2ED5C:
Ani_obj5D_b:	offsetTable
		offsetTableEntry.w byte_2ED66	; 0
		offsetTableEntry.w byte_2ED69	; 1
		offsetTableEntry.w byte_2ED6D	; 2
		offsetTableEntry.w byte_2ED76	; 3
		offsetTableEntry.w byte_2ED7F	; 4
byte_2ED66:	dc.b  $F,  0,$FF
	rev02even
byte_2ED69:	dc.b   7,  1,  2,$FF
	rev02even
byte_2ED6D:	dc.b   7,  5,  5,  5,  5,  5,  5,$FD,  1
	rev02even
byte_2ED76:	dc.b   7,  3,  4,  3,  4,  3,  4,$FD,  1
	rev02even
byte_2ED7F:	dc.b  $F,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,$FD,  1
	even

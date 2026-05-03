; animation script
; off_257EE:
Ani_obj22:	offsetTable
		offsetTableEntry.w byte_257F4	; 0
		offsetTableEntry.w byte_257F7	; 1
		offsetTableEntry.w byte_257FB	; 2
byte_257F4:	dc.b $1F,  1,$FF
	rev02even
byte_257F7:	dc.b   3,  1,  2,$FF
	rev02even
byte_257FB:	dc.b   7,  3,  4,$FC,  4,  3,  1,$FD,  0
	even

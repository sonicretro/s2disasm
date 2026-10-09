; animation script
; off_1F414:
Ani_obj79:	offsetTable
		offsetTableEntry.w byte_1F41A	; 0
		offsetTableEntry.w byte_1F41D	; 1
		offsetTableEntry.w byte_1F420	; 2
byte_1F41A:
	dc.b  $F,  0,$FF
	rev02even
byte_1F41D:
	dc.b  $F,  1,$FF
	rev02even
byte_1F420:
	dc.b   3,  0,  4,$FF
	even

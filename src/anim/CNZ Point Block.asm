; animation script
; off_2C89C:
Ani_objD8:	offsetTable
		offsetTableEntry.w byte_2C8A8	; 0
		offsetTableEntry.w byte_2C8AB	; 1
		offsetTableEntry.w byte_2C8AE	; 2
		offsetTableEntry.w byte_2C8B1	; 3
		offsetTableEntry.w byte_2C8B7	; 4
		offsetTableEntry.w byte_2C8BD	; 5
byte_2C8A8:	dc.b  $F,  0,$FF
	rev02even
byte_2C8AB:	dc.b  $F,  1,$FF
	rev02even
byte_2C8AE:	dc.b  $F,  2,$FF
	rev02even
byte_2C8B1:	dc.b   3,  3,  0,  3,$FD,  0
	rev02even
byte_2C8B7:	dc.b   3,  4,  1,  4,$FD,  1
	rev02even
byte_2C8BD:	dc.b   3,  5,  2,  5,$FD,  2
	even

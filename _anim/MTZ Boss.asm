; animation script
; off_32D7A:
Ani_obj53:	offsetTable
		offsetTableEntry.w byte_32D8A	; 0
		offsetTableEntry.w byte_32D8D	; 1
		offsetTableEntry.w byte_32D91	; 2
		offsetTableEntry.w byte_32DA6	; 3
		offsetTableEntry.w byte_32DAA	; 4
		offsetTableEntry.w byte_32DB5	; 5
		offsetTableEntry.w byte_32DC0	; 6
		offsetTableEntry.w byte_32DC3	; 7
byte_32D8A:	dc.b  $F,  2,$FF
	rev02even
byte_32D8D:	dc.b   1,  0,  1,$FF
	rev02even
byte_32D91:	dc.b   3,  5,  5,  5,  5,  5,  5,  5,  5,  6,  7,  6,  7,  6,  7,  8
		dc.b   9, $A, $B,$FE,  1; 16
	rev02even
byte_32DA6:	dc.b   7, $C, $D,$FF
	rev02even
byte_32DAA:	dc.b   7, $E, $F, $E, $F, $E, $F, $E, $F,$FD,  3
	rev02even
byte_32DB5:	dc.b   7,$10,$10,$10,$10,$10,$10,$10,$10,$FD,  3
	rev02even
byte_32DC0:	dc.b   1,$14,$FC
	rev02even
byte_32DC3:	dc.b   7,$11,$FF
	even

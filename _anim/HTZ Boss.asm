; animation script
; off_30288:
Ani_obj52:	offsetTable
		offsetTableEntry.w byte_30298	; 0
		offsetTableEntry.w byte_3029D	; 1
		offsetTableEntry.w byte_302A2	; 2
		offsetTableEntry.w byte_302A7	; 3
		offsetTableEntry.w byte_302AC	; 4
		offsetTableEntry.w byte_302B0	; 5
		offsetTableEntry.w byte_302B4	; 6
		offsetTableEntry.w byte_302B7	; 7
byte_30298:	dc.b   1,  2,  3,$FD,  1
	rev02even
byte_3029D:	dc.b   2,  4,  5,$FD,  2
	rev02even
byte_302A2:	dc.b   3,  6,  7,$FD,  3
	rev02even
byte_302A7:	dc.b   4,  8,  9,$FD,  4
	rev02even
byte_302AC:	dc.b   5, $A, $B,$FE
	rev02even
byte_302B0:	dc.b   3, $C, $D,$FF
	rev02even
byte_302B4:	dc.b  $F,  1,$FF
	rev02even
byte_302B7:	dc.b   3, $E, $F,$FF
	even

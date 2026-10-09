; animation script
; off_3B4E8:
Ani_objB5:	offsetTable
		offsetTableEntry.w byte_3B4FC	; 0
		offsetTableEntry.w byte_3B506	; 1
		offsetTableEntry.w byte_3B50E	; 2
		offsetTableEntry.w byte_3B516	; 3
		offsetTableEntry.w byte_3B51C	; 4
		offsetTableEntry.w byte_3B524	; 5
		offsetTableEntry.w byte_3B52A	; 6
		offsetTableEntry.w byte_3B532	; 7
		offsetTableEntry.w byte_3B53A	; 8
		offsetTableEntry.w byte_3B544	; 9
byte_3B4FC:	dc.b   7,  0,  1,  2,  3,  4,  5,$FD,  1,  0
byte_3B506:	dc.b   4,  0,  1,  2,  3,  4,$FD,  2
byte_3B50E:	dc.b   3,  5,  0,  1,  2,$FD,  3,  0
byte_3B516:	dc.b   2,  3,  4,  5,$FD,  4
byte_3B51C:	dc.b   1,  0,  1,  2,  3,  4,  5,$FF
byte_3B524:	dc.b   2,  5,  4,  3,$FD,  6
byte_3B52A:	dc.b   3,  2,  1,  0,  5,$FD,  7,  0
byte_3B532:	dc.b   4,  4,  3,  2,  1,  0,$FD,  8
byte_3B53A:	dc.b   7,  5,  4,  3,  2,  1,  0,$FD,  9,  0
byte_3B544:	dc.b $7E,  0,$FF
		even

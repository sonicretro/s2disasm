; animation script
off_39DE2:	offsetTable
		offsetTableEntry.w byte_39DEE	; 0
		offsetTableEntry.w byte_39DF4	; 1
		offsetTableEntry.w byte_39DF8	; 2
		offsetTableEntry.w byte_39DFE	; 3
		offsetTableEntry.w byte_39E14	; 4
		offsetTableEntry.w byte_39E1A	; 5
byte_39DEE:
	dc.b   2,  0,  1,  2,$FF,  0
byte_39DF4:
	dc.b $45,  3,$FD,  0
byte_39DF8:
	dc.b   3,  4,  5,  4,  3,$FC
byte_39DFE:
	dc.b   3,  3,  3,  6,  6,  6,  7,  7,  7,  8,  8,  8,  6,  6,  7,  7
	dc.b   8,  8,  6,  7,  8,$FC; 16
byte_39E14:
	dc.b   2,  6,  7,  8,$FF,  0
byte_39E1A:
	dc.b   3,  8,  7,  6,  8,  8,  7,  7,  6,  6,  8,  8,  8,  7,  7,  7
	dc.b   6,  6,  6,  3,  3,$FC; 16
	even

; animation script
off_39E30:	offsetTable
		offsetTableEntry.w byte_39E36	; 0
		offsetTableEntry.w byte_39E3A	; 1
		offsetTableEntry.w byte_39E3E	; 2
byte_39E36:
	dc.b   1, $B, $C,$FF
byte_39E3A:
	dc.b   1, $D, $E,$FF
byte_39E3E:
	dc.b   1,  9, $A,$FF
	even

; animation script
; off_39E42:
Ani_objAF_c:	offsetTable
		offsetTableEntry.w byte_39E4C	; 0
		offsetTableEntry.w byte_39E54	; 1
		offsetTableEntry.w byte_39E5C	; 2
		offsetTableEntry.w byte_39E60	; 3
		offsetTableEntry.w byte_39E64	; 4
byte_39E4C:	dc.b   3,  4,  3,  2,  1,  0,$FC,  0
byte_39E54:	dc.b   3,  0,  1,  2,  3,  4,$FA,  0
byte_39E5C:	dc.b   3,  5,  5,$FF
byte_39E60:	dc.b   3,  5,  6,$FF
byte_39E64:	dc.b   3,  7,  7,$FF
	even

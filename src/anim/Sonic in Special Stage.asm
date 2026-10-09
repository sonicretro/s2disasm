; animation script
byte_341E2:	dc.b  4, -4
off_341E4:	offsetTable
		offsetTableEntry.w byte_341EE	; 0
		offsetTableEntry.w byte_341F4	; 1
		offsetTableEntry.w byte_341FE	; 2
		offsetTableEntry.w byte_34204	; 3
		offsetTableEntry.w byte_34208	; 4
byte_341EE:
	dc.b   3,  0,  1,  2,  3,$FF
byte_341F4:
	dc.b   3,  4,  5,  6,  7,  8,  9, $A, $B,$FF
byte_341FE:
	dc.b   3, $C, $D, $E, $F,$FF
byte_34204:
	dc.b   1,$10,$11,$FF
byte_34208:
	dc.b   3,  0,  4, $C,  4,  0,  4, $C,  4,$FF
	even

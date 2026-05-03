; animation script
; off_3209C:
Ani_obj51:	offsetTable
		offsetTableEntry.w byte_320B0	; 0
		offsetTableEntry.w byte_320B3	; 1
		offsetTableEntry.w byte_320B9	; 2
		offsetTableEntry.w byte_320BF	; 3
		offsetTableEntry.w byte_320C3	; 4
		offsetTableEntry.w byte_320C8	; 5
		offsetTableEntry.w byte_320D3	; 6
		offsetTableEntry.w byte_320DD	; 7
		offsetTableEntry.w byte_320E1	; 8
		offsetTableEntry.w byte_320E4	; 9
byte_320B0:	dc.b  $F,  1,$FF
	rev02even
byte_320B3:	dc.b  $F,  4,$FF,  5,$FC,  2
	rev02even
byte_320B9:	dc.b  $F,  2,$FF,  3,$FC,  2
	rev02even
byte_320BF:	dc.b   7,  6,  7,$FF
	rev02even
byte_320C3:	dc.b   1, $C, $D, $E,$FF
	rev02even
byte_320C8:	dc.b   7,  8,  9,  8,  9,  8,  9,  8,  9,$FD,  3
	rev02even
byte_320D3:	dc.b   7, $A, $A, $A, $A, $A, $A, $A,$FD,  3
	rev02even
byte_320DD:	dc.b   3,$13,$14,$FF
	rev02even
byte_320E1:	dc.b   1,  0,$FF
	rev02even
byte_320E4:	dc.b   1, $F,$10,$11,$FF
	even

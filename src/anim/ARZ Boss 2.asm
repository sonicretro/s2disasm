; animation script
; off_30DC8:
Ani_obj89_b:	offsetTable
		offsetTableEntry.w byte_30DD4	;  0
		offsetTableEntry.w byte_30DEA	;  2
		offsetTableEntry.w byte_30DEE	;  4
		offsetTableEntry.w byte_30DF1	;  6
		offsetTableEntry.w byte_30DFD	;  8
		offsetTableEntry.w byte_30E00	; $A
byte_30DD4:	dc.b   7,  0,  1,$FF,  2,  3,  2,  3,  2,  3,  2,  3,$FF,  4,  4,  4
		dc.b   4,  4,  4,  4,  4,$FF; 16
	rev02even
byte_30DEA:	dc.b   1,  6,  7,$FF
	rev02even
byte_30DEE:	dc.b  $F,  9,$FF
	rev02even
byte_30DF1:	dc.b   2, $A, $A, $B, $B, $B, $B, $B, $A, $A,$FD,  2
	rev02even
byte_30DFD:	dc.b  $F,  8,$FF
	rev02even
byte_30E00:	dc.b   7,  5,$FF
	even

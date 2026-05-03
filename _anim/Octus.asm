; animation script
; off_2CBDC:
Ani_obj4A:	offsetTable
		offsetTableEntry.w byte_2CBE6	; 0
		offsetTableEntry.w byte_2CBEA	; 1
		offsetTableEntry.w byte_2CBEF	; 2
		offsetTableEntry.w byte_2CBF4	; 3
		offsetTableEntry.w byte_2CBF8	; 4
byte_2CBE6:	dc.b  $F,  1,  0,$FF
	rev02even
byte_2CBEA:	dc.b   3,  1,  2,  3,$FF
	rev02even
byte_2CBEF:	dc.b   2,  5,  6,$FF
	even
byte_2CBF4:	dc.b  $F,  4,$FF
	even
byte_2CBF8:	dc.b   7,  0,  1,$FD,  1
	even

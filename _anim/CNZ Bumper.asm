; animation script
; off_2C610:
Ani_objD7:	offsetTable
		offsetTableEntry.w byte_2C616	; 0
		offsetTableEntry.w byte_2C619	; 1
		offsetTableEntry.w byte_2C61F	; 2
byte_2C616:	dc.b  $F,  0,$FF
	rev02even
byte_2C619:	dc.b   3,  1,  0,  1,$FD,  0
	rev02even
byte_2C61F:	dc.b   3,  2,  0,  2,$FD,  0
	even

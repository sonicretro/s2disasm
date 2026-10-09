; animation script
; off_2B432:
Ani_obj86:	offsetTable
		offsetTableEntry.w byte_2B43C	; 0
		offsetTableEntry.w byte_2B43F	; 1
		offsetTableEntry.w byte_2B445	; 2
		offsetTableEntry.w byte_2B448	; 3
		offsetTableEntry.w byte_2B451	; 4
byte_2B43C:	dc.b  $F,  0,$FF
	rev02even
byte_2B43F:	dc.b   3,  1,  2,  1,$FD,  0
	rev02even
byte_2B445:	dc.b  $F,  4,$FF
	rev02even
byte_2B448:	dc.b   0,  5,  4,  3,  3,  3,  3,$FD,  2
	rev02even
byte_2B451:	dc.b   0,  3,  4,  5,  5,  5,  5,$FD,  2
	even

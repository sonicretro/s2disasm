; ----------------------------------------------------------------------------
; animation script
; ----------------------------------------------------------------------------
; off_29050:
Ani_obj77:	offsetTable
		offsetTableEntry.w Ani_obj77_Close	; 0
		offsetTableEntry.w Ani_obj77_Open	; 1
; byte_29054:
Ani_obj77_Close:
	dc.b   3,  4,  3,  2,  1,  0,$FE,  1
; byte_2905C:
Ani_obj77_Open:
	dc.b   3,  0,  1,  2,  3,  4,$FE,  1
	even

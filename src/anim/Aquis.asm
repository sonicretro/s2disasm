; animation script
; off_2CF6C:
Ani_obj50:	offsetTable
		offsetTableEntry.w Ani_obj50_Normal	; 0
		offsetTableEntry.w byte_2CF7B		; 1
		offsetTableEntry.w Ani_obj50_Bullet	; 2
		offsetTableEntry.w Ani_obj50_Wing	; 3
		offsetTableEntry.w byte_2CF8D		; 4
		offsetTableEntry.w byte_2CF90		; 5
Ani_obj50_Normal:	dc.b  $E,  0,$FF			; byte_2CF78
	rev02even
byte_2CF7B:		dc.b   5,  3,  4,  3,  4,  3,  4,$FF
	rev02even
Ani_obj50_Bullet:	dc.b   3,  5,  6,  7,  6,$FF		; byte_2CF83
	rev02even
Ani_obj50_Wing:		dc.b   3,  1,  2,$FF			; byte_2CF89
	rev02even
byte_2CF8D:		dc.b   1,  5,$FF
	rev02even
byte_2CF90:		dc.b  $E,  8,$FF
	even

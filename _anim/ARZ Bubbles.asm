; -------------------------------------------------------------------------------
; sprite animations
; -------------------------------------------------------------------------------
; animation script
; off_1FBCC:
Ani_obj24:	offsetTable
		offsetTableEntry.w byte_1FBDA	; 0
		offsetTableEntry.w byte_1FBDF	; 1
		offsetTableEntry.w byte_1FBE5	; 2
		offsetTableEntry.w byte_1FBEC	; 3
		offsetTableEntry.w byte_1FBEC	; 4
		offsetTableEntry.w byte_1FBEE	; 5
		offsetTableEntry.w byte_1FBF2	; 6
byte_1FBDA:	dc.b  $E,  0,  1,  2,$FC
		rev02even
byte_1FBDF:	dc.b  $E,  1,  2,  3,  4,$FC
		rev02even
byte_1FBE5:	dc.b  $E,  2,  3,  4,  5,  6,$FC
		rev02even
byte_1FBEC:	dc.b   4,$FC
		rev02even
byte_1FBEE:	dc.b   4,  6,  7,$FC
		rev02even
byte_1FBF2:	dc.b  $F, $E, $F,$FF
		even

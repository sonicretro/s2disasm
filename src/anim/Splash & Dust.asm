; animation script
; off_1DF38:
Ani_obj08:	offsetTable
		offsetTableEntry.w Obj08Ani_Null	; 0
		offsetTableEntry.w Obj08Ani_Splash	; 1
		offsetTableEntry.w Obj08Ani_Dash	; 2
		offsetTableEntry.w Obj08Ani_Skid	; 3
Obj08Ani_Null:	dc.b $1F,  0,$FF
	rev02even
Obj08Ani_Splash:dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,  9,$FD,  0
	rev02even
Obj08Ani_Dash:	dc.b   1, $A, $B, $C, $D, $E, $F,$10,$FF
	rev02even
Obj08Ani_Skid:	dc.b   3,$11,$12,$13,$14,$FC
	even

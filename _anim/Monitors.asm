; animation script
; off_12CCE:
Ani_obj26:	offsetTable
		offsetTableEntry.w Ani_obj26_Static		;  0
		offsetTableEntry.w Ani_obj26_Sonic		;  1
		offsetTableEntry.w Ani_obj26_Tails		;  2
		offsetTableEntry.w Ani_obj26_Eggman		;  3
		offsetTableEntry.w Ani_obj26_Ring		;  4
		offsetTableEntry.w Ani_obj26_Shoes		;  5
		offsetTableEntry.w Ani_obj26_Shield		;  6
		offsetTableEntry.w Ani_obj26_Invincibility	;  7
		offsetTableEntry.w Ani_obj26_Teleport		;  8
		offsetTableEntry.w Ani_obj26_QuestionMark	;  9
		offsetTableEntry.w Ani_obj26_Broken		; $A
; byte_12CE4:
Ani_obj26_Static:
	dc.b	$01	; duration
	dc.b	$00	; frame number (which sprite table to use)
	dc.b	$01	; frame number
	dc.b	$FF	; terminator
; byte_12CE8:
Ani_obj26_Sonic:
	dc.b   1,  0,  2,  2,  1,  2,  2,$FF
; byte_12CF0:
Ani_obj26_Tails:
	dc.b   1,  0,  3,  3,  1,  3,  3,$FF
; byte_12CF8:
Ani_obj26_Eggman:
	dc.b   1,  0,  4,  4,  1,  4,  4,$FF
; byte_12D00:
Ani_obj26_Ring:
	dc.b   1,  0,  5,  5,  1,  5,  5,$FF
; byte_12D08:
Ani_obj26_Shoes:
	dc.b   1,  0,  6,  6,  1,  6,  6,$FF
; byte_12D10:
Ani_obj26_Shield:
	dc.b   1,  0,  7,  7,  1,  7,  7,$FF
; byte_12D18:
Ani_obj26_Invincibility:
	dc.b   1,  0,  8,  8,  1,  8,  8,$FF
; byte_12D20:
Ani_obj26_Teleport:
	dc.b   1,  0,  9,  9,  1,  9,  9,$FF
; byte_12D28:
Ani_obj26_QuestionMark:
	dc.b   1,  0, $A, $A,  1, $A, $A,$FF
; byte_12D30:
Ani_obj26_Broken:
	dc.b   2,  0,  1, $B,$FE,  1
	even

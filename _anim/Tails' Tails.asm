; ---------------------------------------------------------------------------
; Animation script - Tails' tails
; ---------------------------------------------------------------------------
; off_1D2C0:
Obj05AniData:	offsetTable
		offsetTableEntry.w Obj05Ani_Blank	;  0
		offsetTableEntry.w Obj05Ani_Swish	;  1
		offsetTableEntry.w Obj05Ani_Flick	;  2
		offsetTableEntry.w Obj05Ani_Directional	;  3
		offsetTableEntry.w Obj05Ani_DownLeft	;  4
		offsetTableEntry.w Obj05Ani_Down	;  5
		offsetTableEntry.w Obj05Ani_DownRight	;  6
		offsetTableEntry.w Obj05Ani_Spindash	;  7
		offsetTableEntry.w Obj05Ani_Skidding	;  8
		offsetTableEntry.w Obj05Ani_Pushing	;  9
		offsetTableEntry.w Obj05Ani_Hanging	; $A

Obj05Ani_Blank:		dc.b $20,  0,$FF
	rev02even
Obj05Ani_Swish:		dc.b   7,  9, $A, $B, $C, $D,$FF
	rev02even
Obj05Ani_Flick:		dc.b   3,  9, $A, $B, $C, $D,$FD,  1
	rev02even
Obj05Ani_Directional:	dc.b $FC,$49,$4A,$4B,$4C,$FF ; Tails is moving right
	rev02even
Obj05Ani_DownLeft:	dc.b   3,$4D,$4E,$4F,$50,$FF ; Tails is moving up-right
	rev02even
Obj05Ani_Down:		dc.b   3,$51,$52,$53,$54,$FF ; Tails is moving up
	rev02even
Obj05Ani_DownRight:	dc.b   3,$55,$56,$57,$58,$FF ; Tails is moving up-left
	rev02even
Obj05Ani_Spindash:	dc.b   2,$81,$82,$83,$84,$FF
	rev02even
Obj05Ani_Skidding:	dc.b   2,$87,$88,$89,$8A,$FF
	rev02even
Obj05Ani_Pushing:	dc.b   9,$87,$88,$89,$8A,$FF
	rev02even
Obj05Ani_Hanging:	dc.b   9,$81,$82,$83,$84,$FF
	even

; animation script
; off_13686:
Ani_obj0E:	offsetTable
		offsetTableEntry.w Ani_obj0E_Sonic		; 0
		offsetTableEntry.w Ani_obj0E_Tails		; 1
		offsetTableEntry.w Ani_obj0E_FlashingStar	; 2
		offsetTableEntry.w Ani_obj0E_FallingStar	; 3
; byte_1368E:
Ani_obj0E_Sonic:
	dc.b   1
	dc.b   5
	dc.b   6
	dc.b   7
    if ~~fixBugs
	; This appears to be a leftover prototype frame: it's a duplicate of
	; frame $12, except Sonic is missing his right arm. The old frame
	; being here in this animation script causes Sonic to appear with
	; both of his arms missing for a single frame.
	dc.b   8
    endif
	dc.b $FA
	even
; byte_13694:
Ani_obj0E_Tails:
	dc.b   1
	dc.b   0
	dc.b   1
	dc.b   2
	dc.b   3
	dc.b   4
	dc.b $FA
	even
; byte_1369C:
Ani_obj0E_FlashingStar:
	dc.b   1
	dc.b  $C
	dc.b  $D
	dc.b  $E
	dc.b  $D
	dc.b  $C
	dc.b $FA
	even
; byte_136A4:
Ani_obj0E_FallingStar:
	dc.b   3
	dc.b  $C
	dc.b  $F
	dc.b $FF
	even

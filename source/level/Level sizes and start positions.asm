; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Various subroutines relating to levels
; Level size, start locations, camera initialization, software scroll managers, loading and drawing tiles

; ---------------------------------------------------------------------------
; Subroutine to load level boundaries and start locations
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_BFBC:
LevelSizeLoad:
	clr.w	(Scroll_flags).w
	clr.w	(Scroll_flags_BG).w
	clr.w	(Scroll_flags_BG2).w
	clr.w	(Scroll_flags_BG3).w
	clr.w	(Scroll_flags_P2).w
	clr.w	(Scroll_flags_BG_P2).w
	clr.w	(Scroll_flags_BG2_P2).w
	clr.w	(Scroll_flags_BG3_P2).w
	clr.w	(Scroll_flags_copy).w
	clr.w	(Scroll_flags_BG_copy).w
	clr.w	(Scroll_flags_BG2_copy).w
	clr.w	(Scroll_flags_BG3_copy).w
	clr.w	(Scroll_flags_copy_P2).w
	clr.w	(Scroll_flags_BG_copy_P2).w
	clr.w	(Scroll_flags_BG2_copy_P2).w
	clr.w	(Scroll_flags_BG3_copy_P2).w
	clr.b	(Deform_lock).w
	clr.b	(Screen_Shaking_Flag_HTZ).w
	clr.b	(Screen_Shaking_Flag).w
	clr.b	(Scroll_lock).w
	clr.b	(Scroll_lock_P2).w
	moveq	#0,d0
	move.b	d0,(Dynamic_Resize_Routine).w ; load level boundaries
    if gameRevision=2
	move.w	d0,(WFZ_LevEvent_Subrout).w
	move.w	d0,(WFZ_BG_Y_Speed).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	d0,(Camera_BG_Y_offset).w
    endif
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#4,d0
	lea	LevelSize(pc,d0.w),a0
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_X_pos).w
	move.l	d0,(unk_EEC0).w	; unused besides this one write...
	move.l	d0,(Tails_Min_X_pos).w
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_Y_pos).w
	; Warning: unk_EEC4 is only a word long, this line also writes to Camera_Max_Y_pos
	; If you remove this instruction, the camera will scroll up until it kills Sonic
	move.l	d0,(unk_EEC4).w	; unused besides this one write... 
	move.l	d0,(Tails_Min_Y_pos).w
	move.w	#$1010,(Horiz_block_crossed_flag).w
	move.w	#(224/2)-16,(Camera_Y_pos_bias).w
	move.w	#(224/2)-16,(Camera_Y_pos_bias_P2).w
	bra.w	+
; ===========================================================================
; ----------------------------------------------------------------------------
; LEVEL SIZE ARRAY

; This array defines the screen boundaries for each act in the game.
; ----------------------------------------------------------------------------
;				xstart	xend	ystart	yend	; ZID ; Zone
LevelSize: zoneOrderedTable 2,8	; WrdArr_LvlSize
	zoneTableEntry.w	$0,	$29A0,	$0,	$320	; EHZ act 1
	zoneTableEntry.w	$0,	$2940,	$0,	$420	; EHZ act 2
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $01
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $02
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $03
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$2280,	-$100,	$800	; MTZ act 1
	zoneTableEntry.w	$0,	$1E80,	-$100,	$800	; MTZ act 2
	zoneTableEntry.w	$0,	$2A80,	-$100,	$800	; MTZ act 3
	zoneTableEntry.w	$0,	$3FFF,	-$100,	$800
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; WFZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$2800,	$0,	$720	; HTZ act 1
	zoneTableEntry.w	$0,	$3280,	$0,	$720	; HTZ act 2
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $08
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $09
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$2F80,	$0,	$680	; OOZ act 1
	zoneTableEntry.w	$0,	$2D00,	$0,	$680	; OOZ act 2
	zoneTableEntry.w	$0,	$2380,	$3C0,	$720	; MCZ act 1
	zoneTableEntry.w	$0,	$3FFF,	$60,	$720	; MCZ act 2
	zoneTableEntry.w	$0,	$27A0,	$0,	$720	; CNZ act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; CNZ act 2
	zoneTableEntry.w	$0,	$2780,	$0,	$720	; CPZ act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; CPZ act 2
	zoneTableEntry.w	$0,	$1000,	$C8,	 $C8	; DEZ
	zoneTableEntry.w	$0,	$1000,  $C8,	 $C8
	zoneTableEntry.w	$0,	$28C0,	$200,	$600	; ARZ act 1
	zoneTableEntry.w	$0,	$3FFF,	$180,	$710	; ARZ act 2
	zoneTableEntry.w	$0,	$3FFF,	$0,	$000	; SCZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
    zoneTableEnd

; ===========================================================================
+
	tst.b	(Last_star_pole_hit).w		; was a star pole hit yet?
	beq.s	+				; if not, branch
	jsr	(Obj79_LoadData).l		; load the previously saved data
	move.w	(MainCharacter+x_pos).w,d1
	move.w	(MainCharacter+y_pos).w,d0
	bra.s	++
; ===========================================================================
+	; Put the character at the start location for the level
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#5,d0
	lea	StartLocations(pc,d0.w),a1
	moveq	#0,d1
	move.w	(a1)+,d1
	move.w	d1,(MainCharacter+x_pos).w
	moveq	#0,d0
	move.w	(a1),d0
	move.w	d0,(MainCharacter+y_pos).w
+
	subi.w	#$A0,d1
	bcc.s	+
	moveq	#0,d1
+
	move.w	(Camera_Max_X_pos).w,d2
	cmp.w	d2,d1
	blo.s	+
	move.w	d2,d1
+
	move.w	d1,(Camera_X_pos).w
	move.w	d1,(Camera_X_pos_P2).w
	subi.w	#$60,d0
	bcc.s	+
	moveq	#0,d0
+
	cmp.w	(Camera_Max_Y_pos_now).w,d0
	blt.s	+
	move.w	(Camera_Max_Y_pos_now).w,d0
+
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_Y_pos_P2).w
	bsr.w	InitCameraValues
	rts
; End of function LevelSizeLoad

; ===========================================================================
; --------------------------------------------------------------------------------------
; CHARACTER START LOCATION ARRAY

; 2 entries per act, corresponding to the X and Y locations that you want the player to
; appear at when the level starts.
; --------------------------------------------------------------------------------------
StartLocations: zoneOrderedTable 2,4	; WrdArr_StartLoc
	zoneTableBinEntry	2, "startpos/EHZ_1.bin"	; $00
	zoneTableBinEntry	2, "startpos/EHZ_2.bin"
	zoneTableEntry.w	$60,	$28F		; $01
	zoneTableEntry.w	$60,	$2AF
	zoneTableEntry.w	$60,	$1AC		; $02
	zoneTableEntry.w	$60,	$1AC
	zoneTableEntry.w	$60,	$28F		; $03
	zoneTableEntry.w	$60,	$2AF
	zoneTableBinEntry	2, "startpos/MTZ_1.bin"	; $04
	zoneTableBinEntry	2, "startpos/MTZ_2.bin"
	zoneTableBinEntry	2, "startpos/MTZ_3.bin"	; $05
	zoneTableEntry.w	$60,	$2AF
	zoneTableBinEntry	2, "startpos/WFZ.bin"	; $06
	zoneTableEntry.w	$1E0,	$4CC
	zoneTableBinEntry	2, "startpos/HTZ_1.bin"	; $07
	zoneTableBinEntry	2, "startpos/HTZ_2.bin"
	zoneTableEntry.w	$230,	$1AC		; $08
	zoneTableEntry.w	$230,	$1AC
	zoneTableEntry.w	$60,	$28F		; $09
	zoneTableEntry.w	$60,	$2AF
	zoneTableBinEntry	2, "startpos/OOZ_1.bin"	; $0A
	zoneTableBinEntry	2, "startpos/OOZ_2.bin"
	zoneTableBinEntry	2, "startpos/MCZ_1.bin"	; $0B
	zoneTableBinEntry	2, "startpos/MCZ_2.bin"
	zoneTableBinEntry	2, "startpos/CNZ_1.bin"	; $0C
	zoneTableBinEntry	2, "startpos/CNZ_2.bin"
	zoneTableBinEntry	2, "startpos/CPZ_1.bin"	; $0D
	zoneTableBinEntry	2, "startpos/CPZ_2.bin"
	zoneTableBinEntry	2, "startpos/DEZ.bin"	; $0E
	zoneTableEntry.w	$60,	$12D
	zoneTableBinEntry	2, "startpos/ARZ_1.bin"	; $0F
	zoneTableBinEntry	2, "startpos/ARZ_2.bin"
	zoneTableBinEntry	2, "startpos/SCZ.bin"	; $10
	zoneTableEntry.w	$140,	$70
    zoneTableEnd

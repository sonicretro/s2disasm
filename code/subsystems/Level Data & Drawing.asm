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
	move.l	d0,(Camera_Min_X_pos_target).w
	move.l	d0,(Tails_Min_X_pos).w
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_Y_pos).w
	move.l	d0,(Camera_Min_Y_pos_target).w
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
	; EHZ
	zoneTableEntry.w	$0,	$29A0,	$0,	$320	; Act 1
	zoneTableEntry.w	$0,	$2940,	$0,	$420	; Act 2
	; Zone 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; WZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; Zone 3
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; MTZ
	zoneTableEntry.w	$0,	$2280,	-$100,	$800	; Act 1
	zoneTableEntry.w	$0,	$1E80,	-$100,	$800	; Act 2
	; MTZ
	zoneTableEntry.w	$0,	$2A80,	-$100,	$800	; Act 3
	zoneTableEntry.w	$0,	$3FFF,	-$100,	$800	; Act 4
	; WFZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; HTZ
	zoneTableEntry.w	$0,	$2800,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3280,	$0,	$720	; Act 2
	; HPZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; Zone 9
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; OOZ
	zoneTableEntry.w	$0,	$2F80,	$0,	$680	; Act 1
	zoneTableEntry.w	$0,	$2D00,	$0,	$680	; Act 2
	; MCZ
	zoneTableEntry.w	$0,	$2380,	$3C0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$60,	$720	; Act 2
	; CNZ
	zoneTableEntry.w	$0,	$27A0,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; Act 2
	; CPZ
	zoneTableEntry.w	$0,	$2780,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; Act 2
	; DEZ
	zoneTableEntry.w	$0,	$1000,	$C8,	 $C8	; Act 1
	zoneTableEntry.w	$0,	$1000,  $C8,	 $C8	; Act 2
	; ARZ
	zoneTableEntry.w	$0,	$28C0,	$200,	$600	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$180,	$710	; Act 2
	; SCZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$000	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
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
	cmp.w	(Camera_Max_Y_pos).w,d0
	blt.s	+
	move.w	(Camera_Max_Y_pos).w,d0
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
	; EHZ
	zoneTableBinEntry	2, "startpos/EHZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/EHZ_2.bin"	; Act 2
	; Zone 1
	zoneTableBinEntry	2, "startpos/01_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/01_2.bin"	; Act 2
	; WZ
	zoneTableBinEntry	2, "startpos/WZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/WZ_2.bin"	; Act 2
	; Zone 3
	zoneTableBinEntry	2, "startpos/03_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/03_2.bin"	; Act 2
	; MTZ
	zoneTableBinEntry	2, "startpos/MTZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/MTZ_2.bin"	; Act 2
	; MTZ
	zoneTableBinEntry	2, "startpos/MTZ_3.bin"	; Act 3
	zoneTableBinEntry	2, "startpos/MTZ_4.bin"	; Act 4
	; WFZ
	zoneTableBinEntry	2, "startpos/WFZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/WFZ_2.bin"	; Act 2
	; HTZ
	zoneTableBinEntry	2, "startpos/HTZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/HTZ_2.bin"	; Act 2
	; HPZ
	zoneTableBinEntry	2, "startpos/HPZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/HPZ_2.bin"	; Act 2
	; Zone 9
	zoneTableBinEntry	2, "startpos/09_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/09_2.bin"	; Act 2
	; OOZ
	zoneTableBinEntry	2, "startpos/OOZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/OOZ_2.bin"	; Act 2
	; MCZ
	zoneTableBinEntry	2, "startpos/MCZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/MCZ_2.bin"	; Act 2
	; CNZ
	zoneTableBinEntry	2, "startpos/CNZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/CNZ_2.bin"	; Act 2
	; CPZ
	zoneTableBinEntry	2, "startpos/CPZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/CPZ_2.bin"	; Act 2
	; DEZ
	zoneTableBinEntry	2, "startpos/DEZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/DEZ_2.bin"	; Act 2
	; ARZ
	zoneTableBinEntry	2, "startpos/ARZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/ARZ_2.bin"	; Act 2
	; SCZ
	zoneTableBinEntry	2, "startpos/SCZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/SCZ_2.bin"	; Act 2
    zoneTableEnd

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_C258:
InitCameraValues:
	tst.b	(Last_star_pole_hit).w	; was a star pole hit yet?
	bne.s	+			; if yes, branch
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG2_Y_pos).w
	move.w	d1,(Camera_BG_X_pos).w
	move.w	d1,(Camera_BG2_X_pos).w
	move.w	d1,(Camera_BG3_X_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Camera_BG2_Y_pos_P2).w
	move.w	d1,(Camera_BG_X_pos_P2).w
	move.w	d1,(Camera_BG2_X_pos_P2).w
	move.w	d1,(Camera_BG3_X_pos_P2).w
+
	moveq	#0,d2
	move.b	(Current_Zone).w,d2
	add.w	d2,d2
	move.w	InitCam_Index(pc,d2.w),d2
	jmp	InitCam_Index(pc,d2.w)
; End of function InitCameraValues

; ===========================================================================
; off_C296:
InitCam_Index: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w InitCam_EHZ	; EHZ
	zoneOffsetTableEntry.w InitCam_Null0	; Zone 1
	zoneOffsetTableEntry.w InitCam_WZ	; WZ
	zoneOffsetTableEntry.w InitCam_Null0	; Zone 3
	zoneOffsetTableEntry.w InitCam_Std	; MTZ1,2
	zoneOffsetTableEntry.w InitCam_Std	; MTZ3
	zoneOffsetTableEntry.w InitCam_Null1	; WFZ
	zoneOffsetTableEntry.w InitCam_HTZ	; HTZ
	zoneOffsetTableEntry.w InitCam_HPZ	; HPZ
	zoneOffsetTableEntry.w InitCam_Null2	; Zone 9
	zoneOffsetTableEntry.w InitCam_OOZ	; OOZ
	zoneOffsetTableEntry.w InitCam_MCZ	; MCZ
	zoneOffsetTableEntry.w InitCam_CNZ	; CNZ
	zoneOffsetTableEntry.w InitCam_CPZ	; CPZ
	zoneOffsetTableEntry.w InitCam_Null3	; DEZ
	zoneOffsetTableEntry.w InitCam_ARZ	; ARZ
	zoneOffsetTableEntry.w InitCam_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
;loc_C2B8:
InitCam_EHZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	lea	(TempArray_LayerDef).w,a2
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(Camera_BG_X_pos_P2).w
	clr.l	(Camera_BG_Y_pos_P2).w
	clr.l	(Camera_BG2_Y_pos_P2).w
	clr.l	(Camera_BG3_Y_pos_P2).w
	rts
; ===========================================================================
; wtf:
InitCam_Null0:
    if gameRevision=0
	rts
    endif
; ===========================================================================
; Wood_Zone_BG:
InitCam_WZ:
    if gameRevision=0
	asr.w	#2,d0
	addi.w	#$400,d0
	move.w	d0,(Camera_BG_Y_pos).w
	asr.w	#3,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
    endif
; ===========================================================================
;loc_C2E4:
InitCam_Std:
	asr.w	#2,d0
	move.w	d0,(Camera_BG_Y_pos).w
	asr.w	#3,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
; ===========================================================================
;return_C2F2:
InitCam_Null1:
	rts
; ===========================================================================
;loc_C2F4:
InitCam_HTZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	lea	(TempArray_LayerDef).w,a2
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(Camera_BG_X_pos_P2).w
	clr.l	(Camera_BG_Y_pos_P2).w
	clr.l	(Camera_BG2_Y_pos_P2).w
	clr.l	(Camera_BG3_Y_pos_P2).w
	rts
; ===========================================================================
; Hidden_Palace_Zone_BG:
InitCam_HPZ:
    if gameRevision=0
	asr.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
    endif
; ===========================================================================
; Leftover Spring Yard Zone code from Sonic 1

; Unknown_Zone_BG:
;InitCam_SYZ:
    if gameRevision=0
	asl.l	#4,d0
	move.l	d0,d2
	asl.l	#1,d0
	add.l	d2,d0
	asr.l	#8,d0
	addq.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
    endif

; ===========================================================================
;return_C320:
InitCam_Null2:
	rts
; ===========================================================================
;loc_C322:
InitCam_OOZ:
	lsr.w	#3,d0
	addi.w	#$50,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
; ===========================================================================
;loc_C332:
InitCam_MCZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_X_pos_P2).w
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
;loc_C364:
InitCam_CNZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
;loc_C372:
InitCam_CPZ:
	lsr.w	#2,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	lsr.w	#1,d1
	move.w	d1,(Camera_BG2_X_pos).w
	lsr.w	#2,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
; ===========================================================================
;return_C38A:
InitCam_Null3:
	rts
; ===========================================================================
;loc_C38C:
InitCam_ARZ:
	tst.b	(Current_Act).w
	beq.s	+
	subi.w	#$E0,d0
	lsr.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	bra.s	loc_C3A6
; ===========================================================================
+
	subi.w	#$180,d0
	move.w	d0,(Camera_BG_Y_pos).w

loc_C3A6:
	muls.w	#$119,d1
	asr.l	#8,d1
	move.w	d1,(Camera_BG_X_pos).w
	move.w	d1,(Camera_ARZ_BG_X_pos).w
	clr.w	(Camera_BG_X_pos+2).w
	clr.w	(Camera_ARZ_BG_X_pos+2).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	rts
; ===========================================================================
;loc_C3C6:
InitCam_SCZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_C3D0:
DeformBgLayer:
	tst.b	(Deform_lock).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	clr.w	(Scroll_flags).w
	clr.w	(Scroll_flags_BG).w
	clr.w	(Scroll_flags_BG2).w
	clr.w	(Scroll_flags_BG3).w
	clr.w	(Scroll_flags_P2).w
	clr.w	(Scroll_flags_BG_P2).w
	clr.w	(Scroll_flags_BG2_P2).w
	clr.w	(Scroll_flags_BG3_P2).w
	clr.w	(Camera_X_pos_diff).w
	clr.w	(Camera_Y_pos_diff).w
	clr.w	(Camera_X_pos_diff_P2).w
	clr.w	(Camera_Y_pos_diff_P2).w

	; Sky Chase Zone handles scrolling manually, in 'SwScrl_SCZ'.
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.w	+
	tst.w	(Debug_placement_mode).w
	beq.w	loc_C4D0
+
	tst.b	(Scroll_lock).w
	bne.s	DeformBgLayerAfterScrollVert
	lea	(MainCharacter).w,a0 ; a0=character
	lea	(Camera_X_pos).w,a1
	lea	(Camera_Boundaries).w,a2
	lea	(Scroll_flags).w,a3
	lea	(Camera_X_pos_diff).w,a4
	lea	(Camera_Delay).w,a5
	lea	(Sonic_Pos_Record_Buf).w,a6
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	lea	(Camera_Delay_P2).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6
+
	bsr.w	ScrollHoriz
	lea	(Horiz_block_crossed_flag).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos).w,a1
	lea	(Camera_Boundaries).w,a2
	lea	(Camera_Y_pos_diff).w,a4
	move.w	(Camera_Y_pos_bias).w,d3
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.w	(Camera_Y_pos_bias_P2).w,d3
+
	bsr.w	ScrollVerti
	lea	(Verti_block_crossed_flag).w,a2
	bsr.w	SetVertiScrollFlags

DeformBgLayerAfterScrollVert:
	tst.w	(Two_player_mode).w
	beq.s	loc_C4D0
	tst.b	(Scroll_lock_P2).w
	bne.s	loc_C4D0
	lea	(Sidekick).w,a0 ; a0=character
	lea	(Camera_X_pos_P2).w,a1
	lea	(Camera_Boundaries_P2).w,a2
	lea	(Scroll_flags_P2).w,a3
	lea	(Camera_X_pos_diff_P2).w,a4
	lea	(Camera_Delay_P2).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6
	bsr.w	ScrollHoriz
	lea	(Horiz_block_crossed_flag_P2).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos_P2).w,a1
	lea	(Camera_Boundaries_P2).w,a2
	lea	(Camera_Y_pos_diff_P2).w,a4
	move.w	(Camera_Y_pos_bias_P2).w,d3
	bsr.w	ScrollVerti
	lea	(Verti_block_crossed_flag_P2).w,a2
	bsr.w	SetVertiScrollFlags

loc_C4D0:
	bsr.w	RunDynamicLevelEvents
	move.w	(Camera_Y_pos).w,(Vscroll_Factor_FG).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.l	(Camera_X_pos).w,(Camera_X_pos_copy).w
	move.l	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	SwScrl_Index(pc,d0.w),d0
	jmp	SwScrl_Index(pc,d0.w)
; End of function DeformBgLayer

; ===========================================================================
; ---------------------------------------------------------------------------
; JUMP TABLE FOR SOFTWARE SCROLL MANAGERS
;
; "Software scrolling" is my term for what Nemesis (and by extension, the rest
; of the world) calls "rasterized layer deformation".* Software scroll managers
; are needed to achieve certain special camera effects - namely, locking the
; screen for a boss fight and defining the limits of said screen lock, or in
; the case of Sky Chase Zone ($10), moving the camera at a fixed rate through
; a predefined course.
; They are also used for things like controlling the parallax scrolling and
; water ripple effects in EHZ, and moving the clouds in HTZ and the stars in DEZ.
; ---------------------------------------------------------------------------
SwScrl_Index: zoneOrderedOffsetTable 2,1	; JmpTbl_SwScrlMgr
	zoneOffsetTableEntry.w SwScrl_EHZ	; EHZ
	zoneOffsetTableEntry.w SwScrl_Minimal	; Zone 1
	zoneOffsetTableEntry.w SwScrl_WZ	; WZ
	zoneOffsetTableEntry.w SwScrl_Minimal	; Zone 3
	zoneOffsetTableEntry.w SwScrl_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w SwScrl_MTZ	; MTZ3
	zoneOffsetTableEntry.w SwScrl_WFZ	; WFZ
	zoneOffsetTableEntry.w SwScrl_HTZ	; HTZ
	zoneOffsetTableEntry.w SwScrl_HPZ	; HPZ
	zoneOffsetTableEntry.w SwScrl_Minimal	; Zone 9
	zoneOffsetTableEntry.w SwScrl_OOZ	; OOZ
	zoneOffsetTableEntry.w SwScrl_MCZ	; MCZ
	zoneOffsetTableEntry.w SwScrl_CNZ	; CNZ
	zoneOffsetTableEntry.w SwScrl_CPZ	; CPZ
	zoneOffsetTableEntry.w SwScrl_DEZ	; DEZ
	zoneOffsetTableEntry.w SwScrl_ARZ	; ARZ
	zoneOffsetTableEntry.w SwScrl_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
; loc_C51E:
SwScrl_Title:
	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Automatically scroll the background.
	addq.w	#1,(Camera_X_pos).w

	; Calculate the background X position from the foreground X position.
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#2,d2

	; Update the background's (and foreground's) horizontal scrolling.
	lea	(Horiz_Scroll_Buf).w,a1

	; Do 160 lines that don't move.
	moveq	#0,d0
	move.w	#160-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	; Do 32 lines that scroll with the camera.
	move.w	d2,d0
	move.w	#32-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	; Make the 'ripple' animate every 8 frames.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	; Do 16 lines that scroll with the camera and 'ripple'.
	move.w	#16-1,d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	; The remaining 16 lines are not set.

	rts
; ===========================================================================
; loc_C57E:
SwScrl_EHZ:
	; Use different background scrolling code for two player mode.
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_EHZ_2P

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This creates an elaborate parallax effect.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	#0,d0

	; Do 22 lines.
	move.w	#22-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#6,d0

	; Do 58 lines.
	move.w	#58-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3

	; Make the 'ripple' animate every 8 frames.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	(SwScrl_RippleData).l,a2
	lea	(a2,d1.w),a2

	; Do 21 lines.
	move.w	#21-1,d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	move.w	#0,d0

	; Do 11 lines.
	move.w	#11-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0

	; Do 16 lines.
	move.w	#16-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0
	move.w	d0,d1
	asr.w	#1,d1
	add.w	d1,d0

	; Do 16 lines.
	move.w	#16-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.l	d0,d4
	swap	d4
	move.w	d2,d0
	asr.w	#1,d0
	move.w	d2,d1
	asr.w	#3,d1
	sub.w	d1,d0
	ext.l	d0
	asl.l	#8,d0
	divs.w	#$30,d0
	ext.l	d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3
	asr.w	#3,d3

	; Do 15 lines.
	move.w	#15-1,d1
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	; Do 18 lines.
	move.w	#18/2-1,d1
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	; Do 45 lines.
	move.w	#45/3-1,d1
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	; 22+58+21+11+16+16+15+18+45=222.
	; Only 222 out of 224 lines have been processed.

    if fixBugs
	; The bottom two lines haven't had their H-scroll values set.
	; Knuckles in Sonic 2 fixes this with the following code:
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
    endif

	rts
; ===========================================================================
; horizontal offsets for the water rippling effect
; byte_C682:
SwScrl_RippleData:
	dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0; 16
	dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3; 32
	dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0; 48
	dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3; 64
	dc.b   1,  2	; 66
	even
; ===========================================================================
; loc_C6C4:
SwScrl_EHZ_2P:
	; Make the 'ripple' animate every 8 frames.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	; Do Player 1's screen.

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This creates an elaborate parallax effect.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	; Do 11 lines.
	move.w	#11-1,d1
	bsr.s	.doBackground

	; Do Player 2's screen.

	; Update the background's vertical scrolling.
	moveq	#0,d0
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#224,(Vscroll_Factor_P2_BG).w

	; Update the foregrounds's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#224,(Vscroll_Factor_P2_FG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This creates an elaborate parallax effect.
	; Tails' screen is slightly taller, to fill the gap between the two
	; screens.
	lea	(Horiz_Scroll_Buf+(112-4)*2*2).w,a1
	move.w	(Camera_X_pos_P2).w,d0
	; Do 11+4 lines.
	move.w	#11+4-1,d1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_C71A:
.doBackground:
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	#0,d0

-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#6,d0

	; Do 29 lines.
	move.w	#29-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea_	SwScrl_RippleData,a2
	lea	(a2,d1.w),a2

	; Do 11 lines.
	move.w	#11-1,d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	move.w	#0,d0

	; Do 5 lines.
	move.w	#5-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0

	; Do 8 lines.
	move.w	#8-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0
	move.w	d0,d1
	asr.w	#1,d1
	add.w	d1,d0

	; Do 8 lines.
	move.w	#8-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#1,d0
	move.w	d2,d1
	asr.w	#3,d1
	sub.w	d1,d0
	ext.l	d0
	asl.l	#8,d0
	divs.w	#$30,d0
	ext.l	d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3
	asr.w	#3,d3

	; Do 40 lines.
	move.w	#40-1,d1
-	move.w	d2,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	; 11+29+11+5+8+8+40=112.
	; No missing lines here.

	rts
; End of function sub_C71A

; ===========================================================================
; unused...
; loc_C7BA: SwScrl_Lev2:
SwScrl_WZ:
    if gameRevision<2
	; Just a duplicate of 'SwScrl_Minimal'.

	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#224-1,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-
    endif

	rts
; ===========================================================================
; loc_C7F2:
SwScrl_MTZ:
	; Just a duplicate of 'SwScrl_Minimal'.

	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#224-1,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_C82A:
SwScrl_WFZ:
	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	moveq	#scroll_flag_bg1_left,d6
	bsr.w	SetHorizScrollFlagsBG

	; Ditto.
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#scroll_flag_bg1_up_whole_row_2,d6
	bsr.w	SetVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	move.l	(Camera_BG_X_pos).w,d0
	; This can be removed if the getaway ship's entry uses d0 instead.
	move.l	d0,d1
	lea	(TempArray_LayerDef).w,a2
	move.l	d0,(a2)+				; Static parts of BG (generally no clouds in them)
	move.l	d1,(a2)+				; Eggman's getaway ship
	; Note: this is bugged: this tallies only the cloud speeds. It works fine
	; if you are standing still, but makes the clouds move faster when going
	; right and slower when going left. This is exactly the opposite of what
	; should happen.
	addi.l	#$8000,(a2)+			; Larger clouds
	addi.l	#$4000,(a2)+			; Medium clouds
	addi.l	#$2000,(a2)+			; Small clouds
	lea	(SwScrl_WFZ_Transition_Array).l,a3
	cmpi.w	#$2700,(Camera_X_pos).w
	bhs.s	.got_array
	lea	(SwScrl_WFZ_Normal_Array).l,a3

.got_array:
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	andi.w	#$7FF,d1
	moveq	#0,d0
	moveq	#0,d3

	; Find the first visible scrolling section
.seg_loop:
	move.b	(a3)+,d0		; Number of lines in this segment
	addq.w	#1,a3			; Skip index
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.seg_loop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	move.w	#224-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.b	-1(a3),d3		; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.row_loop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.next_row		; Branch if not
	move.b	(a3)+,d1		; Fetch a new line count
	move.b	(a3)+,d3		; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.next_row:
	dbf	d2,.row_loop

	rts
; ===========================================================================
; WFZ BG scrolling data
; Each pair of bytes corresponds to one scrolling segment of the BG, and
; the bytes have the following meaning:
; 	number of lines, index into TempArray_LayerDef
; byte_C8CA
SwScrl_WFZ_Transition_Array:
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $80,  4
	dc.b $80,  4
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
;byte_C916
SwScrl_WFZ_Normal_Array:
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
; This array is missing data for the last $80 lines compared to the transition array.
; This causes the lower clouds to read data from the start of SwScrl_HTZ.
; These are the missing entries:
    if fixBugs
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
    endif
; ===========================================================================
; loc_C964:
SwScrl_HTZ:
	; Use different background scrolling code for two player mode.
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_HTZ_2P	; never used in normal gameplay

	tst.b	(Screen_Shaking_Flag_HTZ).w
	bne.w	HTZ_Screen_Shake

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This creates an elaborate parallax effect.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	d2,d0
	asr.w	#3,d0

	; Do 128 lines that move together with the camera.
	move.w	#128-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	; The remaining lines compose the animating clouds.
	move.l	d0,d4
	move.w	(TempArray_LayerDef+$22).w,d0
	addq.w	#4,(TempArray_LayerDef+$22).w
	sub.w	d0,d2
	move.w	d2,d0
	move.w	d0,d1
	asr.w	#1,d0
	asr.w	#4,d1
	sub.w	d1,d0
	ext.l	d0
	asl.l	#8,d0
	divs.w	#$70,d0
	ext.l	d0
	asl.l	#8,d0
	lea	(TempArray_LayerDef).w,a2	; See 'loc_3FE5C'.
	moveq	#0,d3
	move.w	d1,d3
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3

	moveq	#4-1,d1
-	move.w	d3,(a2)+
	move.w	d3,(a2)+
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	; Do 8 lines.
	add.l	d0,d0
	add.l	d0,d0
	move.w	d3,d4
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+

	; Do 7 lines.
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#7-1,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	; Do 8 lines.
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#8-1,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	; Do 10 lines.
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#10-1,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	; Do 15 lines.
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#15-1,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	; Do 48 lines.
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3

	move.w	#3-1,d2
-	move.w	d3,d4

	move.w	#16-1,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d2,--

	; 128 + 8 + 7 + 8 + 10 + 15 + 48 = 224
	; All lines have been written.

	rts
; ===========================================================================

;loc_CA92:
HTZ_Screen_Shake:
	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	lsl.l	#8,d4
	moveq	#scroll_flag_bg1_left,d6
	bsr.w	SetHorizScrollFlagsBG

	; Ditto.
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#scroll_flag_bg1_up,d6
	bsr.w	SetVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w ; Redundant.
	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos).w,(Vscroll_Factor_FG).w
	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	+

	; Make the screen shake.
	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#224-1,d1
	move.w	(Camera_X_pos).w,d0
	add.w	d2,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	add.w	d2,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; Unused background code for Hill Top Zone in two player mode!
; Unfortunately, it doesn't do anything very interesting: it's just a basic,
; flat background with no parallax effect.
; loc_CB10:
SwScrl_HTZ_2P:
	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#6,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#2,d5
	moveq	#0,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; ...But then immediately wipe them. Strange.
	; I guess the only reason 'SetHorizVertiScrollFlagsBG' is called is
	; so that 'Camera_BG_X_pos' and 'Camera_BG_Y_pos' are updated?
	move.b	#0,(Scroll_flags_BG).w

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#112-1,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	; Update 'Camera_BG_X_pos_P2'.
	move.w	(Camera_X_pos_diff_P2).w,d4
	ext.l	d4
	asl.l	#6,d4
	add.l	d4,(Camera_BG_X_pos_P2).w

	; Update the background's vertical scrolling.
	moveq	#0,d0
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#224,(Vscroll_Factor_P2_BG).w

	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#224,(Vscroll_Factor_P2_FG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	; Tails' screen is slightly taller, to fill the gap between the two
	; screens.
	lea	(Horiz_Scroll_Buf+(112-4)*2*2).w,a1
	move.w	#112+4-1,d1
	move.w	(Camera_X_pos_P2).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos_P2).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; unused...
; loc_CBA0:
SwScrl_HPZ:
	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#6,d4
	moveq	#scroll_flag_bg1_left,d6
	bsr.w	SetHorizScrollFlagsBG

	; Ditto.
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#7,d5
	moveq	#scroll_flag_bg1_up_whole_row_2,d6
	bsr.w	SetVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Rather than scroll each individual line of the background, this
	; zone scrolls entire blocks of lines (16 lines) at once. The scroll
	; value of each row is written to 'TempArray_LayerDef', before it is
	; applied to 'Horiz_Scroll_Buf' in 'SwScrl_HPZ_Continued'. This is
	; vaguely similar to how Chemical Plant Zone scrolls its background,
	; even overflowing 'Horiz_Scroll_Buf' in the same way.
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2

	; Do 8 line blocks.
	move.w	d2,d0
	asr.w	#1,d0

	move.w	#8-1,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	; Do 7 line blocks.
	; This also does the 7 line blocks that get skipped later.
	move.w	d2,d0
	asr.w	#3,d0
	sub.w	d2,d0
	ext.l	d0
	asl.l	#3,d0
	divs.w	#8,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3
	asr.w	#1,d3
	lea	(TempArray_LayerDef+(8+7+26+7)*2).w,a2
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,(a1)+
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	move.w	d3,-(a2)
	move.w	d3,-(a2)
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	move.w	d3,-(a2)
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,-(a2)

	; Do 26 line blocks.
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

	move.w	#26-1,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	; Skip 7 line blocks which were done earlier.
	adda.w	#7*2,a1

	; Do 24 line blocks.
	move.w	d2,d0
	asr.w	#1,d0

	move.w	#24-1,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	; We're done creating the line block scroll values: now to apply them
	; to 'Horiz_Scroll_Buf'.

	; Take the background's Y position, and use it to select a line block
	; in 'TempArray_LayerDef'. Since each line block is 16 lines long,
	; this code essentially divides the Y position by 16, and then
	; multiples it by 2 to turn it into an offset into
	; 'TempArray_LayerDef'.
	lea	(TempArray_LayerDef).w,a2
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,d2
	andi.w	#$3F0,d0
	lsr.w	#3,d0
	lea	(a2,d0.w),a2

	; Begin filling 'Horiz_Scroll_Buf' starting with the line block
	; scroll data pointed to by 'a2'.
	bra.w	SwScrl_HPZ_Continued
; ===========================================================================
; loc_CC66:
SwScrl_OOZ:
    if fixBugs
	; As described below, part of Oil Ocean Zone's background is rendered
	; unused because the basic background drawer that this zone uses is
	; unable to draw it without making the clouds and sun disappear.
	; However, it is possible to fix this by using the advanced
	; background drawer that Chemical Plant Zone uses.

	; Update scroll flags, to dynamically load more of the background as
	; the player moves around.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#5,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Move BG1's scroll flags into BG3...
	move.b	(Scroll_flags_BG).w,(Scroll_flags_BG3).w

	; ...then clear BG1's scroll flags.
	; This zone basically uses its own dynamic background loader.
	clr.b	(Scroll_flags_BG).w
    else
	; Update 'Camera_BG_X_pos', since there's no call to
	; 'SetHorizScrollFlagsBG' or 'SetHorizVertiScrollFlagsBG' to do it
	; for us.
	move.w	(Camera_X_pos_diff).w,d0
	ext.l	d0
	asl.l	#5,d0
	add.l	d0,(Camera_BG_X_pos).w

	; Set the flags to dynamically load the background as it moves.
	; Note that this is only done vertically: Oil Ocean Zone does have
	; extra background art that can only be seen with horizontal dynamic
	; loading, but, because of this, it is never seen.
	move.w	(Camera_Y_pos_diff).w,d0
	ext.l	d0
	asl.l	#5,d0
	move.l	(Camera_BG_Y_pos).w,d3
	add.l	d3,d0
	moveq	#scroll_flag_bg1_up_whole_row,d6
	bsr.w	SetVertiScrollFlagsBG2
    endif

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; Curiously, Oil Ocean Zone fills 'Horiz_Scroll_Buf' starting from
	; the end and working backwards towards the beginning, unlike other
	; zones.
	lea	(Horiz_Scroll_Buf+224*2*2).w,a1

	; Set up the foreground part of the horizontal scroll value.
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0

	; Set up the background part of the horizontal scroll value.
	move.w	(Camera_BG_X_pos).w,d7
	neg.w	d7

	; Figure out how many lines to do for the bottom (factory) part the
	; background.
	move.w	(Camera_BG_Y_pos).w,d1
	subi.w	#80,d1
	bcc.s	+
	moveq	#0,d1
+
	subi.w	#176,d1
	bcs.s	+
	moveq	#0,d1
+
	; This will keep track of how many lines we have left to output.
	move.w	#224-1,d6

	; Do the factory part of the background.
	add.w	d6,d1
	move.w	d7,d0
	bsr.s	.doLines

	; Now do some clouds.
	bsr.s	.doMediumClouds
	bsr.s	.doSlowClouds
	bsr.s	.doFastClouds

	; Do another slow cloud layer, except 7 lines tall instead of 8.
	move.w	d7,d0
	asr.w	#4,d0
	moveq	#7-1,d1
	bsr.s	.doLines

	; Make the sun's heat haze effect animate every 8 frames.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	; Do the sun.
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	moveq	#33-1,d1
-	move.b	(a2)+,d0
	ext.w	d0
	move.l	d0,-(a1)
	subq.w	#1,d6
	bmi.s	+	; rts
	dbf	d1,-

	; Do some more clouds.
	bsr.s	.doMediumClouds
	bsr.s	.doSlowClouds
	bsr.s	.doFastClouds
	bsr.s	.doSlowClouds
	bsr.s	.doMediumClouds

	; Do the final, empty part of the sky.
	move.w	d7,d0
	moveq	#72-1,d1
	bsr.s	.doLines
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_CD0A: OOZ_BGScroll_FastClouds:
.doFastClouds:
	move.w	d7,d0
	asr.w	#2,d0
	bra.s	+
; End of function .doFastClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_CD10: OOZ_BGScroll_MediumClouds:
.doMediumClouds:
	move.w	d7,d0
	asr.w	#3,d0
	bra.s	+
; End of function .doMediumClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_CD16: OOZ_BGScroll_SlowClouds:
.doSlowClouds:
	move.w	d7,d0
	asr.w	#4,d0

+
	; Each 'layer' of cloud is 8 lines thick.
	moveq	#8-1,d1
; End of function .doSlowClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Scrolls min(d6,d1+1) lines by an (constant) amount specified in d0

; sub_CD1C: OOZ_BGScroll_Lines:
.doLines:
	; Output a line.
	move.l	d0,-(a1)

	; If we've reach 224 lines, bail.
	subq.w	#1,d6
	bmi.s	+

	; Do the next line.
	dbf	d1,.doLines

	rts
; ===========================================================================
+
	; Do not return to 'SwScrl_OOZ'.
	addq.l	#4,sp
	rts
; End of function .doLines

; ===========================================================================
; loc_CD2C:
SwScrl_MCZ:
	; Use different background scrolling code for two player mode.
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_MCZ_2P

	; Set the flags to dynamically load the background as it moves.
	; Note that this is only done vertically: Mystic Cave Zone's
	; background repeats horizontally, so dynamic horizontal loading is
	; not needed.
	move.w	(Camera_Y_pos).w,d0
	move.l	(Camera_BG_Y_pos).w,d3
	; Curiously, the background moves vertically at different speeds
	; depending on what the current act is.
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#320,d0
	bra.s	++
+
	divu.w	#6,d0
	subi.w	#16,d0
+
	swap	d0
	moveq	#scroll_flag_bg1_up_whole_row_2,d6
	bsr.w	SetVertiScrollFlagsBG2

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Handle the screen shaking during the boss fight.
	moveq	#0,d2
    if fixBugs
	; The screen shaking is not applied to the background parallax
	; scrolling, causing it to distort. This is trivial to fix: just add
	; the Y component of the shaking to the camera's Y position.
	moveq	#0,d3
    endif
	tst.b	(Screen_Shaking_Flag).w
	beq.s	+

	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
    if fixBugs
	; Ditto.
	move.w	d0,d3
    endif
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	lea	(TempArray_LayerDef).w,a2
	lea	15*2(a2),a3
	move.w	(Camera_X_pos).w,d0

	; This code is duplicated twice in 'SwScrl_MCZ_2P'.
	ext.l	d0
	asl.l	#4,d0
	divs.w	#10,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1

	move.w	d1,(a3)+
	move.w	d1,7*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,5*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,3*2(a2)
	move.w	d1,8*2(a2)
	move.w	d1,14*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2*2(a2)
	move.w	d1,9*2(a2)
	move.w	d1,13*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,1*2(a2)
	move.w	d1,10*2(a2)
	move.w	d1,12*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,0*2(a2)
	move.w	d1,11*2(a2)
	; Duplicate code end.

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	lea	(SwScrl_MCZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
    if fixBugs
	; Ditto.
	add.w	d3,d1
    endif
	moveq	#0,d0

	; Find the first visible scrolling section
.segmentLoop:
	move.b	(a3)+,d0		; Number of lines in this segment
	addq.w	#2,a2
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.segmentLoop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	subq.w	#2,a2
	move.w	#224-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.rowLoop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.nextRow		; Branch if not
	move.b	(a3)+,d1		; Fetch a new line count
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.nextRow:
	dbf	d2,.rowLoop

	rts
; ===========================================================================
; byte_CE6C:
SwScrl_MCZ_RowHeights:
	dc.b 37
	dc.b 23	; 1
	dc.b 18	; 2
	dc.b  7	; 3
	dc.b  7	; 4
	dc.b  2	; 5
	dc.b  2	; 6
	dc.b 48	; 7
	dc.b 13	; 8
	dc.b 19	; 9
	dc.b 32	; 10
	dc.b 64	; 11
	dc.b 32	; 12
	dc.b 19	; 13
	dc.b 13	; 14
	dc.b 48	; 15
	dc.b  2	; 16
	dc.b  2	; 17
	dc.b  7	; 18
	dc.b  7	; 19
	dc.b 32	; 20
	dc.b 18	; 21
	dc.b 23	; 22
	dc.b 37	; 23
	even
; ===========================================================================
; loc_CE84:
SwScrl_MCZ_2P:
	; Note that the flags to dynamically load the background as it moves
	; aren't set here. This is because the background is not dynamically
	; loaded in two player mode: instead, the whole background is
	; pre-loaded into Plane B. This is possible because Plane B is larger
	; in two player mode (able to hold 512x512 pixels instead of 512x256).
	moveq	#0,d0
	move.w	(Camera_Y_pos).w,d0
	; Curiously, the background moves vertically at different speeds
	; depending on what the current act is.
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#320,d0
	bra.s	++
+
	divu.w	#6,d0
	subi.w	#16,d0
+
	; Update 'Camera_BG_Y_pos'.
	move.w	d0,(Camera_BG_Y_pos).w

	; Update the background's vertical scrolling.
	move.w	d0,(Vscroll_Factor_BG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w

	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	lea	(TempArray_LayerDef).w,a2
	lea	15*2(a2),a3
	move.w	(Camera_X_pos).w,d0

	; A huuuuuuuuuuuuge chunk of duplicate code from 'SwScrl_MCZ'.
	ext.l	d0
	asl.l	#4,d0
	divs.w	#10,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1

	move.w	d1,(a3)+
	move.w	d1,7*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,5*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,3*2(a2)
	move.w	d1,8*2(a2)
	move.w	d1,14*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2*2(a2)
	move.w	d1,9*2(a2)
	move.w	d1,13*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,1*2(a2)
	move.w	d1,10*2(a2)
	move.w	d1,12*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,0*2(a2)
	move.w	d1,11*2(a2)
	; Duplicate code end.

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	lea	(SwScrl_MCZ2P_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	lsr.w	#1,d1

	moveq	#0,d0

	; Find the first visible scrolling section
.segmentLoop:
	move.b	(a3)+,d0		; Number of lines in this segment
	addq.w	#2,a2
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.segmentLoop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	subq.w	#2,a2
	move.w	#112-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.rowLoop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.nextRow		; Branch if not
	move.b	(a3)+,d1		; Fetch a new line count
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.nextRow:
	dbf	d2,.rowLoop

	bra.s	+
; ===========================================================================
; byte_CF90:
SwScrl_MCZ2P_RowHeights:
	dc.b 19
	dc.b 11	; 1
	dc.b  9	; 2
	dc.b  4	; 3
	dc.b  3	; 4
	dc.b  1	; 5
	dc.b  1	; 6
	dc.b 24	; 7
	dc.b  6	; 8
	dc.b 10	; 9
	dc.b 16	; 10
	dc.b 32	; 11
	dc.b 16	; 12
	dc.b 10	; 13
	dc.b  6	; 14
	dc.b 24	; 15
	dc.b  1	; 16
	dc.b  1	; 17
	dc.b  3	; 18
	dc.b  4	; 19
	dc.b 16	; 20
	dc.b  9	; 21
	dc.b 11	; 22
	dc.b 19	; 23
	even
; ===========================================================================
+
	; Note that the flags to dynamically load the background as it moves
	; aren't set here. This is because the background is not dynamically
	; loaded in two player mode: instead, the whole background is
	; pre-loaded into Plane B. This is possible because Plane B is larger
	; in two player mode (able to hold 512x512 pixels instead of 512x256).
	moveq	#0,d0
	move.w	(Camera_Y_pos_P2).w,d0
	; Curiously, the background moves vertically at different speeds
	; depending on what the current act is.
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#320,d0
	bra.s	++
+
	divu.w	#6,d0
	subi.w	#16,d0
+
	; Update 'Camera_BG_Y_pos_P2'.
	move.w	d0,(Camera_BG_Y_pos_P2).w

	; Update the background's vertical scrolling.
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#224,(Vscroll_Factor_P2_BG).w

	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#224,(Vscroll_Factor_P2_FG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w

	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	lea	(TempArray_LayerDef).w,a2
	lea	15*2(a2),a3
	move.w	(Camera_X_pos_P2).w,d0

	; A huuuuuuuuuuuuge chunk of duplicate code from 'SwScrl_MCZ'.
	ext.l	d0
	asl.l	#4,d0
	divs.w	#10,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1

	move.w	d1,(a3)+
	move.w	d1,7*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,5*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,3*2(a2)
	move.w	d1,8*2(a2)
	move.w	d1,14*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2*2(a2)
	move.w	d1,9*2(a2)
	move.w	d1,13*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,1*2(a2)
	move.w	d1,10*2(a2)
	move.w	d1,12*2(a2)

	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,0*2(a2)
	move.w	d1,11*2(a2)
	; Duplicate code end.

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	; Tails' screen is slightly taller, to fill the gap between the two
	; screens.
	lea_	SwScrl_MCZ2P_RowHeights+1,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf+(112-4)*2*2).w,a1
	move.w	(Camera_BG_Y_pos_P2).w,d1
	lsr.w	#1,d1
	; Extend the first segment of 'SwScrl_MCZ2P_RowHeights' by 4 lines.
	moveq	#19+4,d0
	bra.s	.useOwnSegmentSize
; ===========================================================================

.segmentLoop:
	; Find the first visible scrolling section
	move.b	(a3)+,d0		; Number of lines in this segment

.useOwnSegmentSize:
	addq.w	#2,a2
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.segmentLoop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	subq.w	#2,a2
	move.w	#112+4-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos_P2).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.rowLoop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.nextRow		; Branch if not
	move.b	(a3)+,d1		; Fetch a new line count
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.nextRow:
	dbf	d2,.rowLoop

	rts
; ===========================================================================
; loc_D0C6:
SwScrl_CNZ:
	; Use different background scrolling code for two player mode.
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_CNZ_2P

	; Update 'Camera_BG_Y_pos'.
	move.w	(Camera_Y_pos).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos).w

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	move.w	(Camera_X_pos).w,d2
	bsr.w	SwScrl_CNZ_GenerateScrollValues

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	lea	(SwScrl_CNZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1

	moveq	#0,d0

	; Find the first visible scrolling section
.segmentLoop:
	move.b	(a3)+,d0		; Number of lines in this segment
	addq.w	#2,a2
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.segmentLoop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	subq.w	#2,a2
	move.w	#224-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.rowLoop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.nextRow		; Branch if not

.nextSegment:
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP
	move.b	(a3)+,d1		; Fetch a new line count
	beq.s	.isRipplingSegment	; Branch if special segment

.nextRow:
	dbf	d2,.rowLoop

	rts
; ===========================================================================

.isRipplingSegment:
	; This row is 16 pixels tall.
	move.w	#16-1,d1
	move.w	d0,d3
	; Animate the rippling effect every 8 frames.
	move.b	(Vint_runcount+3).w,d0
	lsr.w	#3,d0
	neg.w	d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a4
	lea	(a4,d0.w),a4

.rippleLoop:
	move.b	(a4)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,.rippleLoop

	; We've done 16 lines, so subtract them from the counter.
	subi.w	#16,d2
	bra.s	.nextSegment
; ===========================================================================
; byte_D156:
SwScrl_CNZ_RowHeights:
	dc.b  16
	dc.b  16
	dc.b  16
	dc.b  16
	dc.b  16
	dc.b  16
	dc.b  16
	dc.b  16
	dc.b   0	; Special (actually has a height of 16)
	dc.b 240
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_D160:
SwScrl_CNZ_GenerateScrollValues:
	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	lea	(TempArray_LayerDef).w,a1
	move.w	d2,d0
	asr.w	#3,d0
	sub.w	d2,d0
	ext.l	d0
	asl.l	#5,d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3

	move.w	#7-1,d1
-	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	move.w	d2,d0
	asr.w	#3,d0
	move.w	d0,4(a1)
	asr.w	#1,d0
	move.w	d0,(a1)+
	move.w	d0,(a1)+
	rts
; End of function sub_D160

; ===========================================================================
; loc_D194:
SwScrl_CNZ_2P:
	; Do player 1's background.

	; Update 'Camera_BG_Y_pos'.
	move.w	(Camera_Y_pos).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos).w

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w

	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	move.w	(Camera_X_pos).w,d2
	bsr.w	SwScrl_CNZ_GenerateScrollValues

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d0
	move.w	#112-1,d2
	lea	(SwScrl_CNZ2P_RowHeights_P1).l,a3
	bsr.s	.doBackground

	; Do player 2's background.

	; Update 'Camera_BG_Y_pos'.
	move.w	(Camera_Y_pos_P2).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos_P2).w

	; Update the background's vertical scrolling.
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#224,(Vscroll_Factor_P2_BG).w

	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#224,(Vscroll_Factor_P2_FG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w

	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	move.w	(Camera_X_pos_P2).w,d2
	bsr.w	SwScrl_CNZ_GenerateScrollValues

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	; Tails' screen is slightly taller, to fill the gap between the two
	; screens.
	lea	(Horiz_Scroll_Buf+(112-4)*2*2).w,a1
	move.w	(Camera_BG_Y_pos_P2).w,d1
	moveq	#0,d0
	move.w	(Camera_X_pos_P2).w,d0
	move.w	#112+4-1,d2
	lea	(SwScrl_CNZ2P_RowHeights_P2).l,a3

    if fixBugs
	; Use a similar trick to Mystic Cave Zone: override the first value
	; in the code here.
	lsr.w	#1,d1
	lea	(TempArray_LayerDef).w,a2
	; Extend the first segment of 'SwScrl_CNZ2P_RowHeights' by 4 lines.
	move.w	#8+4,d3
	bra.s	.useOwnSegmentSize
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_D216:
.doBackground:
	lsr.w	#1,d1
	lea	(TempArray_LayerDef).w,a2
	moveq	#0,d3

	; Find the first visible scrolling section
.segmentLoop:
	move.b	(a3)+,d3		; Number of lines in this segment

.useOwnSegmentSize:
	addq.w	#2,a2
	sub.w	d3,d1			; Does this segment have any visible lines?
	bcc.s	.segmentLoop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	subq.w	#2,a2
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.rowLoop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.nextRow		; Branch if not

.nextSegment:
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP
	move.b	(a3)+,d1		; Fetch a new line count
	beq.s	.isRipplingSegment	; Branch if special segment

.nextRow:
	dbf	d2,.rowLoop

	rts
; ===========================================================================

.isRipplingSegment:
	; This row is 8 pixels tall.
	move.w	#8-1,d1
	move.w	d0,d3
	; Animate the rippling effect every 8 frames.
	move.b	(Vint_runcount+3).w,d0
	lsr.w	#3,d0
	neg.w	d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a4
	lea	(a4,d0.w),a4

.rippleLoop:
	move.b	(a4)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,.rippleLoop

	; We've done 8 lines, so subtract them from the counter.
	subq.w	#8,d2
	bra.s	.nextSegment
; End of function sub_D216

; ===========================================================================
    if ~~fixBugs
	; This doesn't have the effect that the developers intended: rather
	; than just extend the topmost segment, it creates additional
	; segments which cause the later segments to use the wrong scroll
	; values.
	dc.b   4
SwScrl_CNZ2P_RowHeights_P2:
	dc.b   4
    endif
SwScrl_CNZ2P_RowHeights_P1:
	dc.b   8
    if fixBugs
	; See above.
SwScrl_CNZ2P_RowHeights_P2:
    endif
	dc.b   8
	dc.b   8
	dc.b   8
	dc.b   8
	dc.b   8
	dc.b   8
	dc.b   8
	dc.b   0	; Special (actually has a height of 8)
	dc.b 120
	even
; ===========================================================================
; loc_D27C:
SwScrl_CPZ:
	; Update scroll flags, to dynamically load more of the background as
	; the player moves around.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Ditto.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#7,d4
	moveq	#scroll_flag_advanced_bg2_left,d6
	bsr.w	SetHorizScrollFlagsBG2

	; Update 'Camera_BG2_Y_pos'.
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,(Camera_BG2_Y_pos).w

	; Update the background's vertical scrolling.
	move.w	d0,(Vscroll_Factor_BG).w

	; Merge BG1's and BG2's scroll flags into BG3...
	move.b	(Scroll_flags_BG).w,d0
	or.b	(Scroll_flags_BG2).w,d0
	move.b	d0,(Scroll_flags_BG3).w

	; ...then clear BG1's and BG2's scroll flags.
	; This zone basically uses its own dynamic background loader.
	clr.b	(Scroll_flags_BG).w
	clr.b	(Scroll_flags_BG2).w

	; Every 8 frames, subtract 1 from 'TempArray_LayerDef'.
	; This animates the 'special line block'.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	lea	(CPZ_CameraSections+1).l,a0
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,d2
	andi.w	#$3F0,d0
	lsr.w	#4,d0
	lea	(a0,d0.w),a0	; 'a0' goes completely unused after this...
	move.w	d0,d4
	; 'd4' now holds the index of the current line block.

	lea	(Horiz_Scroll_Buf).w,a1

    if fixBugs
	move.w	#224/16-1,d1
    else
	; The '+1' is so that, if one block is partially-offscreen at the
	; top, then another will fill the gap at the bottom of the screen.
	; This causes 'Horiz_Scroll_Buf' to overflow due to a lack of
	; bounds-checking. This was likely a deliberate optimisation. Still,
	; it's possible to avoid this without any performance penalty with a
	; little extra code. See below.
	move.w	#224/16+1-1,d1
    endif

	; Set up the foreground part of the horizontal scroll value.
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0

	; Get the offset into the starting block.
	andi.w	#$F,d2

    if fixBugs
	; See above.

	; Back this up, because we'll need it later.
	move.w	d2,d5
	; If this is 0, then we won't need to do an extra block, so skip
	; ahead.
	beq.s	.doLineBlocks
	; Process the first set of line blocks.
	bsr.s	.doLineBlocks

	; Do one last line block.
	moveq	#1-1,d1

	; Invert 'd2' to get the number of lines in the first block that we
	; skipped, so that we can do them now.
	move.w	#$10,d2
	sub.w	d5,d2

	; Process the final line block.
.doLineBlocks:
    endif

	; Behaviour depends on which line block we're processing.
	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#18,d4
	beq.s	.doPartialSpecialLineBlock
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0

	add.w	d2,d2
	jmp	.doPartialLineBlock(pc,d2.w)
; ===========================================================================

.doFullLineBlock:
	; Behaviour depends on which line block we're processing.
	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#18,d4
	beq.s	.doFullSpecialLineBlock
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0

	; This works like a Duff's Device.
.doPartialLineBlock:
    rept 16
	move.l	d0,(a1)+
    endm
	addq.b	#1,d4	; Next line block.
	dbf	d1,.doFullLineBlock
	rts
; ===========================================================================
; loc_D34A:
.doPartialSpecialLineBlock:
	; Invert the offset into the starting block to obtain the number of
	; lines to output minus 1.
	move.w	#$F,d0
	sub.w	d2,d0
	move.w	d0,d2
	bra.s	+
; ===========================================================================
.doFullSpecialLineBlock:
	; A block is 16 lines.
	move.w	#16-1,d2
+
	; The special block row has a ripple effect applied to it.
	move.w	(Camera_BG_X_pos).w,d3
	neg.w	d3
	move.w	(TempArray_LayerDef).w,d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a2
	lea	(a2,d0.w),a2

.doLine:
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d2,.doLine

	addq.b	#1,d4	; Next block.
	dbf	d1,.doFullLineBlock
	rts
; ===========================================================================
; loc_D382:
SwScrl_DEZ:
	; Update scroll flags, to dynamically load more of the background as
	; the player moves around.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#8,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

    if fixBugs
	; The screen shaking is not applied to the background parallax
	; scrolling, causing it to distort. This is trivial to fix: just add
	; the Y component of the shaking to the camera's Y position.
	; This block of code also has to be moved to the start of this
	; function.

	; Handle screen shaking when the final boss explodes.
	moveq	#0,d2
	moveq	#0,d3
	tst.b	(Screen_Shaking_Flag).w
	beq.s	++	; rts
	subq.w	#1,(DEZ_Shake_Timer).w
	bpl.s	+
	clr.b	(Screen_Shaking_Flag).w
+
	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,d3
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
    endif

	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	move.w	(Camera_X_pos).w,d4
	lea	(TempArray_LayerDef).w,a2

	; Empty space with no stars.
	move.w	d4,(a2)+

	; These seemingly random numbers control how fast each row of stars
	; scrolls by.
	addq.w	#3,(a2)+
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+
	addq.w	#1,(a2)+
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#2,(a2)+
	addq.w	#6,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#1,(a2)+
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+
	addq.w	#3,(a2)+
	addq.w	#2,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#1,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#2,(a2)+
	addq.w	#1,(a2)

	; This is to make one row go at half speed (1 pixel every other
	; frame).
	move.w	(a2)+,d0
	moveq	#0,d1
	move.w	d0,d1
	lsr.w	#1,d0
	move.w	d0,(a2)+

	; More star speeds...
	addq.w	#3,(a2)+
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+

	; Now do Earth.
	swap	d1
	move.l	d1,d0
	lsr.l	#3,d1
	sub.l	d1,d0
	swap	d0
	move.w	d0,4(a2)

	swap	d0
	sub.l	d1,d0
	swap	d0
	move.w	d0,2(a2)

	swap	d0
	sub.l	d1,d0
	swap	d0
	move.w	d0,(a2)+

	; Skip past the rows we just did.
	addq.w	#2*2,a2

	addq.w	#1,(a2)+

	; Do the sky.
	move.w	d4,(a2)+
	move.w	d4,(a2)+
	move.w	d4,(a2)+

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	lea	(SwScrl_DEZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
    if fixBugs
	; Apply screen shaking effect to the background parallax scrolling.
	add.w	d3,d1
    endif

	moveq	#0,d0

	; Find the first visible scrolling section
.segmentLoop:
	move.b	(a3)+,d0		; Number of lines in this segment
	addq.w	#2,a2
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.segmentLoop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	subq.w	#2,a2
	move.w	#224-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.rowLoop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.nextRow		; Branch if not
	move.b	(a3)+,d1		; Fetch a new line count
	move.w	(a2)+,d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.nextRow:
	dbf	d2,.rowLoop

    if ~~fixBugs
	; The screen shaking is not applied to the background parallax
	; scrolling, causing it to distort. This is trivial to fix: just add
	; the Y component of the shaking to the camera's Y position.
	; This block of code also has to be moved to the start of this
	; function.

	; Handle screen shaking when the final boss explodes.
	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	++	; rts
	subq.w	#1,(DEZ_Shake_Timer).w
	bpl.s	+
	clr.b	(Screen_Shaking_Flag).w
+
	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
    endif

	rts
; ===========================================================================
; byte_D48A:
SwScrl_DEZ_RowHeights:
	; Empty space.
	dc.b 128
	; Stars.
	dc.b   8	; 1
	dc.b   8	; 2
	dc.b   8	; 3
	dc.b   8	; 4
	dc.b   8	; 5
	dc.b   8	; 6
	dc.b   8	; 7
	dc.b   8	; 8
	dc.b   8	; 9
	dc.b   8	; 10
	dc.b   8	; 11
	dc.b   8	; 12
	dc.b   8	; 13
	dc.b   8	; 14
	dc.b   8	; 15
	dc.b   8	; 16
	dc.b   8	; 17
	dc.b   8	; 18
	dc.b   8	; 19
	dc.b   8	; 20
	dc.b   8	; 21
	dc.b   8	; 22
	dc.b   8	; 23
	dc.b   8	; 24
	dc.b   8	; 25
	dc.b   8	; 26
	dc.b   8	; 27
	dc.b   8	; 28
	; The edge of Earth.
	dc.b   3	; 29
	dc.b   5	; 30
	dc.b   8	; 31
	dc.b  16	; 32
	; The sky.
	dc.b 128	; 33
	dc.b 128	; 34
	dc.b 128	; 35
	even
; ===========================================================================
; loc_D4AE:
SwScrl_ARZ:
	; Update scroll flags, to dynamically load more of the background as
	; the player moves around.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	muls.w	#281,d4
	moveq	#scroll_flag_bg1_left,d6
	bsr.w	SetHorizScrollFlagsBG_ARZ

	; Ditto.
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#7,d5
	; Curiously, the background moves vertically at different speeds
	; depending on what the current act is.
	tst.b	(Current_Act).w
	bne.s	+
	asl.l	#1,d5
+
	moveq	#scroll_flag_bg1_up_whole_row_2,d6
	bsr.w	SetVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Handle the screen shaking during the boss fight.
	moveq	#0,d2
    if fixBugs
	; The screen shaking is not applied to the background parallax
	; scrolling, causing it to distort. This is trivial to fix: just add
	; the Y component of the shaking to the camera's Y position.
	moveq	#0,d3
    endif
	tst.b	(Screen_Shaking_Flag).w
	beq.s	.screenNotShaking

	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	; Shake camera Y-pos
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
    if fixBugs
	; Ditto
	move.w d0,d3
    endif
	; Shake camera X-pos
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w

.screenNotShaking:
	; Populate a list of horizontal scroll values for each row.
	; The background is broken up into multiple rows of arbitrary
	; heights, with each row getting its own scroll value.
	; This is used to create an elaborate parallax effect.
	lea	(TempArray_LayerDef).w,a2	; Starts at BG scroll row 1
	lea	3*2(a2),a3			; Starts at BG scroll row 4

	; Set up the speed of each row (there are 16 rows in total)
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#10,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1

	; Set row 4's speed
	swap	d1
	move.w	d1,(a3)+	; Top row of background moves 10 times slower than foreground
	swap	d1
	add.l	d1,d1
	add.l	d0,d1
	; Set rows 5-10's speed
    rept 6
	swap	d1
	move.w	d1,(a3)+	; Next row moves 3 times faster than top row, then next row is 4 times faster, then 5, etc.
	swap	d1
	add.l	d0,d1
    endm
	; Set row 11's speed
	swap	d1
	move.w	d1,(a3)+

	; These instructions reveal that ARZ had slightly different scrolling,
	; at one point:
	; Above the background's mountains is a row of leaves, which is actually
	; composed of three separately-scrolling rows. According to this code,
	; the first and third rows were meant to scroll at a different speed to the
	; second. Possibly due to how bad it looks, the speed values are overwritten
	; a few instructions later, so all three move at the same speed.
	; This code seems to pre-date the Simon Wai build, which uses the same
	; scrolling as the final game.
	move.w	d1,(a2)		; Set row 1's speed
	move.w	d1,4(a2)	; Set row 3's speed

	move.w	(Camera_BG_X_pos).w,d0
	move.w	d0,2(a2)	; Set row 2's speed
	move.w	d0,$16(a2)	; Set row 12's speed
	_move.w	d0,0(a2)	; Overwrite row 1's speed (now same as row 2's)
	move.w	d0,4(a2)	; Overwrite row 3's speed (now same as row 2's)
	move.w	d0,12*2(a2)	; Set row 13's speed
	move.w	d0,13*2(a2)	; Set row 14's speed
	move.w	d0,14*2(a2)	; Set row 15's speed
	move.w	d0,15*2(a2)	; Set row 16's speed

	; Use the list of row scroll values and a list of row heights to fill
	; 'Horiz_Scroll_Buf'.
	lea	(SwScrl_ARZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
    if fixBugs
	; Ditto
	add.w	d3,d1
    endif
	moveq	#0,d0

	; Find which row of background is visible at the top of the screen
.findTopRowLoop:
	move.b	(a3)+,d0	; Get row height
	addq.w	#2,a2		; Next row speed (note: is off by 2. This is fixed below)
	sub.w	d0,d1
	bcc.s	.findTopRowLoop	; If current row is above the screen, loop and do next row

	neg.w	d1		; d1 now contains how many pixels of the row is currently on-screen
	subq.w	#2,a2		; Get correct row speed

	move.w	#224-1,d2 	; Height of screen
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0		; Store FG X-pos in upper 16-bits...
	move.w	(a2)+,d0	; ...and BG X-pos in lower 16 bits, as Horiz_Scroll_Buf expects it
	neg.w	d0

-	move.l	d0,(a1)+	; Write 1 FG Horizontal Scroll value, and 1 BG Horizontal Scroll value
	subq.w	#1,d1		; Loop until row at top of screen is done
	bne.s	+
	move.b	(a3)+,d1	; Once that row is done, go to next row...
	move.w	(a2)+,d0	; ...and use next speed
	neg.w	d0
+	dbf	d2,-		; Loop until Horiz_Scroll_Buf is full

	rts
; ===========================================================================
; byte_D5CE:
SwScrl_ARZ_RowHeights:
	dc.b 176
	dc.b 112	; 1
	dc.b  48	; 2
	dc.b  96	; 3
	dc.b  21	; 4
	dc.b  12	; 5
	dc.b  14	; 6
	dc.b   6	; 7
	dc.b  12	; 8
	dc.b  31	; 9
	dc.b  48	; 10
	dc.b 192	; 11
	dc.b 240	; 12
	dc.b 240	; 13
	dc.b 240	; 14
	dc.b 240	; 15
	even
; ===========================================================================
; loc_D5DE:
SwScrl_SCZ:
	tst.w	(Debug_placement_mode).w
	bne.w	SwScrl_Minimal

	; Set the flags to dynamically load the foreground manually. This is
	; normally done in 'DeformBgLayer'.
	lea	(Camera_X_pos).w,a1
	lea	(Scroll_flags).w,a3
	lea	(Camera_X_pos_diff).w,a4
	move.w	(Tornado_Velocity_X).w,d0
	move.w	(a1),d4
	add.w	(a1),d0
	move.w	d0,d1
	sub.w	(a1),d1
	asl.w	#8,d1
	move.w	d0,(a1)
	move.w	d1,(a4)
	lea	(Horiz_block_crossed_flag).w,a2
	bsr.w	SetHorizScrollFlags

	; Ditto.
	lea	(Camera_Y_pos).w,a1
	lea	(Camera_Y_pos_diff).w,a4
	move.w	(Tornado_Velocity_Y).w,d0
	move.w	(a1),d4
	add.w	(a1),d0
	move.w	d0,d1
	sub.w	(a1),d1
	asl.w	#8,d1
	move.w	d0,(a1)
	move.w	d1,(a4)
	lea	(Verti_block_crossed_flag).w,a2
	bsr.w	SetVertiScrollFlags

	; Update scroll flags, to dynamically load more of the background as
	; the player moves around.
	move.w	(Camera_X_pos_diff).w,d4
	beq.s	+
	move.w	#$100,d4
+
	ext.l	d4
	asl.l	#7,d4
	moveq	#0,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#224-1,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_D666:
SwScrl_Minimal:
	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This is very basic: there is no parallax effect here.
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#224-1,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; unused...
; loc_D69E:
SwScrl_HPZ_Continued:
	lea	(Horiz_Scroll_Buf).w,a1

    if fixBugs
	move.w	#224/16-1,d1
    else
	; The '+1' is so that, if one block is partially-offscreen at the
	; top, then another will fill the gap at the bottom of the screen.
	; This causes 'Horiz_Scroll_Buf' to overflow due to a lack of
	; bounds-checking. This was likely a deliberate optimisation. Still,
	; it's possible to avoid this without any performance penalty with a
	; little extra code. See below.
	move.w	#224/16+1-1,d1
    endif

	; Set up the foreground part of the horizontal scroll value.
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0

	andi.w	#$F,d2

    if fixBugs
	; See above.

	; Back this up, because we'll need it later.
	move.w	d2,d5
	; If this is 0, then we won't need to do an extra block, so skip
	; ahead.
	beq.s	.doLineBlocks
	; Process the first set of line blocks.
	bsr.s	.doLineBlocks

	; Do one last line block.
	moveq	#1-1,d1

	; Invert 'd2' to get the number of lines in the first block that we
	; skipped, so that we can do them now.
	move.w	#$10,d2
	sub.w	d5,d2

	; Process the final line block.
.doLineBlocks:
    endif

	; Turn d2 into an offset into '.doPartialLineBlock' (each instruction
	; is 2 bytes long).
	add.w	d2,d2
	; Get line block scroll value.
	move.w	(a2)+,d0
	; Output the first line block.
	jmp	.doPartialLineBlock(pc,d2.w)
; ===========================================================================

.doFullLineBlock:
	; Get next line block scroll value.
	move.w	(a2)+,d0

	; This works like a Duff's Device.
.doPartialLineBlock:
    rept 16
	move.l	d0,(a1)+
    endm
	dbf	d1,.doFullLineBlock

	rts

; ---------------------------------------------------------------------------
; Subroutine to set horizontal scroll flags
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D6E2:
SetHorizScrollFlags:
	move.w	(a1),d0		; get camera X pos
	andi.w	#$10,d0
	move.b	(a2),d1
	eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
	bne.s	++		; if not, branch
	eori.b	#$10,(a2)
	move.w	(a1),d0		; get camera X pos
	sub.w	d4,d0		; subtract previous camera X pos
	bpl.s	+		; branch if the camera has moved forward
	bset	#scroll_flag_fg_left,(a3)	; set moving back in level bit
	rts
; ===========================================================================
+
	bset	#scroll_flag_fg_right,(a3)	; set moving forward in level bit
+
	rts
; End of function SetHorizScrollFlags

; ---------------------------------------------------------------------------
; Subroutine to scroll the camera horizontally
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D704:
ScrollHoriz:
	move.w	(a1),d4		; get camera X pos
	tst.b	(Teleport_flag).w
	bne.s	.return		; if a teleport is in progress, return
    if fixBugs
	; To prevent the bug that is described below, this caps the position
	; array index offset so that it does not access position data from
	; before the spin dash was performed. Note that this required
	; modifications to 'Sonic_UpdateSpindash' and 'Tails_UpdateSpindash'.
	move.b	Horiz_scroll_delay_val-Camera_Delay(a5),d1	; should scrolling be delayed?
	beq.s	.scrollNotDelayed				; if not, branch
	lsl.b	#2,d1		; multiply by 4, the size of a position buffer entry
	subq.b	#1,Horiz_scroll_delay_val-Camera_Delay(a5)	; reduce delay value
	move.b	Sonic_Pos_Record_Index+1-Camera_Delay(a5),d0
	sub.b	Horiz_scroll_delay_val+1-Camera_Delay(a5),d0
	cmp.b	d0,d1
	blo.s	.doNotCap
	move.b	d0,d1
.doNotCap:
    else
	; The intent of this code is to make the camera briefly lag behind the
	; player right after releasing a spin dash, however it does this by
	; simply making the camera use position data from previous frames. This
	; means that if the camera had been moving recently enough, then
	; releasing a spin dash will cause the camera to jerk around instead of
	; remain still. This can be encountered by running into a wall, and
	; quickly turning around and spin dashing away. Sonic 3 would have had
	; this same issue with the Fire Shield's dash abiliity, but it shoddily
	; works around the issue by resetting the old position values to the
	; current position (see 'Reset_Player_Position_Array').
	move.w	Horiz_scroll_delay_val-Camera_Delay(a5),d1	; should scrolling be delayed?
	beq.s	.scrollNotDelayed				; if not, branch
	subi.w	#$100,d1					; reduce delay value
	move.w	d1,Horiz_scroll_delay_val-Camera_Delay(a5)
	moveq	#0,d1
	move.b	Horiz_scroll_delay_val-Camera_Delay(a5),d1	; get delay value
	lsl.b	#2,d1		; multiply by 4, the size of a position buffer entry
	addq.b	#4,d1
    endif
	move.w	Sonic_Pos_Record_Index-Camera_Delay(a5),d0	; get current position buffer index
	sub.b	d1,d0
	move.w	(a6,d0.w),d0	; get Sonic's position a certain number of frames ago
	andi.w	#$3FFF,d0
	bra.s	.checkIfShouldScroll	; use that value for scrolling
; ===========================================================================
; loc_D72E:
.scrollNotDelayed:
	move.w	x_pos(a0),d0
; loc_D732:
.checkIfShouldScroll:
	sub.w	(a1),d0
	subi.w	#(320/2)-16,d0		; is the player less than 144 pixels from the screen edge?
	blt.s	.scrollLeft	; if he is, scroll left
	subi.w	#16,d0		; is the player more than 159 pixels from the screen edge?
	bge.s	.scrollRight	; if he is, scroll right
	clr.w	(a4)		; otherwise, don't scroll
; return_D742:
.return:
	rts
; ===========================================================================
; loc_D744:
.scrollLeft:
	cmpi.w	#-16,d0
	bgt.s	.maxNotReached
	move.w	#-16,d0		; limit scrolling to 16 pixels per frame
; loc_D74E:
.maxNotReached:
	add.w	(a1),d0						; get new camera position
	cmp.w	Camera_Min_X_pos-Camera_Boundaries(a2),d0	; is it greater than the minimum position?
	bgt.s	.doScroll					; if it is, branch
	move.w	Camera_Min_X_pos-Camera_Boundaries(a2),d0	; prevent camera from going any further back
	bra.s	.doScroll
; ===========================================================================
; loc_D758:
.scrollRight:
	cmpi.w	#16,d0
	blo.s	.maxNotReached2
	move.w	#16,d0
; loc_D762:
.maxNotReached2:
	add.w	(a1),d0						; get new camera position
	cmp.w	Camera_Max_X_pos-Camera_Boundaries(a2),d0	; is it less than the max position?
	blt.s	.doScroll					; if it is, branch
	move.w	Camera_Max_X_pos-Camera_Boundaries(a2),d0	; prevent camera from going any further forward
; loc_D76E:
.doScroll:
	move.w	d0,d1
	sub.w	(a1),d1		; subtract old camera position
	asl.w	#8,d1		; shift up by a byte
	move.w	d0,(a1)		; set new camera position
	move.w	d1,(a4)		; set difference between old and new positions
	rts
; End of function ScrollHoriz

; ---------------------------------------------------------------------------
; Subroutine to scroll the camera vertically
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; The upper 16 bits of Camera_Y_pos is the actual Y-pos, the lower ones seem
; unused, yet this code goes to a strange extent to manage them.
;sub_D77A:
ScrollVerti:
	moveq	#0,d1
	move.w	y_pos(a0),d0
	sub.w	(a1),d0		; subtract camera Y pos
	cmpi.w	#-$100,(Camera_Min_Y_pos).w ; does the level wrap vertically?
	bne.s	.noWrap		; if not, branch
	andi.w	#$7FF,d0
; loc_D78E:
.noWrap:
	btst	#2,status(a0)	; is the player rolling?
	beq.s	.notRolling	; if not, branch
	subq.w	#5,d0		; subtract difference between standing and rolling heights
    if fixBugs
	; Tails is shorter than Sonic, so the above subtraction actually
	; causes the camera to jolt slightly when he goes from standing to
	; rolling, and vice versa. Not even Sonic 3 & Knuckles fixed this.
	; To fix this, just adjust the subtraction to suit Tails (who is four
	; pixels shorter).
	cmpi.b	#ObjID_Tails,id(a0)
	bne.s	.notRolling
	addq.w	#4,d0
    endif
; loc_D798:
.notRolling:
	btst	#1,status(a0)			; is the player in the air?
	beq.s	.checkBoundaryCrossed_onGround	; if not, branch
;.checkBoundaryCrossed_inAir:
	; If Sonic's in the air, he has $20 pixels above and below him to move without disturbing the camera.
	; The camera movement is also only capped at $10 pixels.
	addi.w	#$20,d0
	sub.w	d3,d0
	bcs.s	.doScroll_fast	; If Sonic is above the boundary, scroll to catch up to him
	subi.w	#$40,d0
	bcc.s	.doScroll_fast	; If Sonic is below the boundary, scroll to catch up to him
	tst.b	(Camera_Max_Y_Pos_Changing).w	; is the max Y pos changing?
	bne.s	.scrollUpOrDown_maxYPosChanging	; if it is, branch
	bra.s	.doNotScroll
; ===========================================================================
; loc_D7B6:
.checkBoundaryCrossed_onGround:
	; On the ground, the camera follows Sonic very strictly.
	sub.w	d3,d0				; subtract camera bias
	bne.s	.decideScrollType		; If Sonic has moved, scroll to catch up to him
	tst.b	(Camera_Max_Y_Pos_Changing).w	; is the max Y pos changing?
	bne.s	.scrollUpOrDown_maxYPosChanging	; if it is, branch
; loc_D7C0:
.doNotScroll:
	clr.w	(a4)		; clear Y position difference (Camera_Y_pos_diff)
	rts
; ===========================================================================
; loc_D7C4:
.decideScrollType:
	cmpi.w	#(224/2)-16,d3	; is the camera bias normal?
	bne.s	.doScroll_slow	; if not, branch
	mvabs.w	inertia(a0),d1	; get player ground velocity, force it to be positive
	cmpi.w	#$800,d1	; is the player travelling very fast?
	bhs.s	.doScroll_fast	; if he is, branch
;.doScroll_medium:
	move.w	#6<<8,d1	; If player is going too fast, cap camera movement to 6 pixels per frame
	cmpi.w	#6,d0		; is player going down too fast?
	bgt.s	.scrollDown_max	; if so, move camera at capped speed
	cmpi.w	#-6,d0		; is player going up too fast?
	blt.s	.scrollUp_max	; if so, move camera at capped speed
	bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
; loc_D7EA:
.doScroll_slow:
	move.w	#2<<8,d1	; If player is going too fast, cap camera movement to 2 pixels per frame
	cmpi.w	#2,d0		; is player going down too fast?
	bgt.s	.scrollDown_max	; if so, move camera at capped speed
	cmpi.w	#-2,d0		; is player going up too fast?
	blt.s	.scrollUp_max	; if so, move camera at capped speed
	bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
; loc_D7FC:
.doScroll_fast:
	; related code appears in ScrollBG
	; S3K uses 24 instead of 16
	move.w	#16<<8,d1	; If player is going too fast, cap camera movement to $10 pixels per frame
	cmpi.w	#16,d0		; is player going down too fast?
	bgt.s	.scrollDown_max	; if so, move camera at capped speed
	cmpi.w	#-16,d0		; is player going up too fast?
	blt.s	.scrollUp_max	; if so, move camera at capped speed
	bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
; loc_D80E:
.scrollUpOrDown_maxYPosChanging:
	moveq	#0,d0		; Distance for camera to move = 0
	move.b	d0,(Camera_Max_Y_Pos_Changing).w	; clear camera max Y pos changing flag
; loc_D814:
.scrollUpOrDown:
	moveq	#0,d1
	move.w	d0,d1		; get position difference
	add.w	(a1),d1		; add old camera Y position
	tst.w	d0		; is the camera to scroll down?
	bpl.w	.scrollDown	; if it is, branch
	bra.w	.scrollUp
; ===========================================================================
; loc_D824:
.scrollUp_max:
	neg.w	d1	; make the value negative (since we're going backwards)
	ext.l	d1
	asl.l	#8,d1	; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
	add.l	(a1),d1	; add the two, getting the new Camera_Y_pos value
	swap	d1	; actual Y-coordinate is now the low word
; loc_D82E:
.scrollUp:
	cmp.w	Camera_Min_Y_pos-Camera_Boundaries(a2),d1	; is the new position less than the minimum Y pos?
	bgt.s	.doScroll	; if not, branch
	cmpi.w	#-$100,d1
	bgt.s	.minYPosReached
	andi.w	#$7FF,d1
	andi.w	#$7FF,(a1)
	bra.s	.doScroll
; ===========================================================================
; loc_D844:
.minYPosReached:
	move.w	Camera_Min_Y_pos-Camera_Boundaries(a2),d1	; prevent camera from going any further up
	bra.s	.doScroll
; ===========================================================================
; loc_D84A:
.scrollDown_max:
	ext.l	d1
	asl.l	#8,d1		; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
	add.l	(a1),d1		; add the two, getting the new Camera_Y_pos value
	swap	d1		; actual Y-coordinate is now the low word
; loc_D852:
.scrollDown:
	cmp.w	Camera_Max_Y_pos-Camera_Boundaries(a2),d1	; is the new position greater than the maximum Y pos?
	blt.s	.doScroll	; if not, branch
	subi.w	#$800,d1
	bcs.s	.maxYPosReached
	subi.w	#$800,(a1)
	bra.s	.doScroll
; ===========================================================================
; loc_D864:
.maxYPosReached:
	move.w	Camera_Max_Y_pos-Camera_Boundaries(a2),d1	; prevent camera from going any further down
; loc_D868:
.doScroll:
	move.w	(a1),d4		; get old pos (used by SetVertiScrollFlags)
	swap	d1		; actual Y-coordinate is now the high word, as Camera_Y_pos expects it
	move.l	d1,d3
	sub.l	(a1),d3
	ror.l	#8,d3
	move.w	d3,(a4)		; set difference between old and new positions
	move.l	d1,(a1)		; set new camera Y pos
	rts
; End of function ScrollVerti

; ---------------------------------------------------------------------------
; Subroutine to set vertical scroll flags
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


SetVertiScrollFlags:
	move.w	(a1),d0		; get camera Y pos
	andi.w	#$10,d0
	move.b	(a2),d1
	eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
	bne.s	++		; if not, branch
	eori.b	#$10,(a2)
	move.w	(a1),d0		; get camera Y pos
	sub.w	d4,d0		; subtract old camera Y pos
	bpl.s	+		; branch if the camera has scrolled down
	bset	#scroll_flag_fg_up,(a3)	; set moving up in level bit
	rts
; ===========================================================================
+
	bset	#scroll_flag_fg_down,(a3)	; set moving down in level bit
+
	rts
; End of function SetVertiScrollFlags


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; d4 is horizontal, d5 vertical, derived from $FFFFEEB0 & $FFFFEEB2 respectively

;sub_D89A: ;Hztl_Vrtc_Bg_Deformation:
SetHorizVertiScrollFlagsBG: ; used by lev2, MTZ, HTZ, CPZ, DEZ, SCZ, Minimal
	move.l	(Camera_BG_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0	; add x-shift for this frame
	move.l	d0,(Camera_BG_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG).w,d3
	eor.b	d3,d1
	bne.s	++
	eori.b	#$10,(Horiz_block_crossed_flag_BG).w
	sub.l	d2,d0
	bpl.s	+
	bset	#scroll_flag_bg1_left,(Scroll_flags_BG).w
	bra.s	++
; ===========================================================================
+
	bset	#scroll_flag_bg1_right,(Scroll_flags_BG).w
+
	move.l	(Camera_BG_Y_pos).w,d3
	move.l	d3,d0
	add.l	d5,d0	; add y-shift for this frame
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Verti_block_crossed_flag_BG).w,d2
	eor.b	d2,d1
	bne.s	++	; rts
	eori.b	#$10,(Verti_block_crossed_flag_BG).w
	sub.l	d3,d0
	bpl.s	+
	bset	#scroll_flag_bg1_up,(Scroll_flags_BG).w
	rts
; ===========================================================================
+
	bset	#scroll_flag_bg1_down,(Scroll_flags_BG).w
+
	rts
; End of function SetHorizVertiScrollFlagsBG


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D904: ;Horizontal_Bg_Deformation:
SetHorizScrollFlagsBG:	; used by WFZ, HTZ, HPZ
	move.l	(Camera_BG_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0	; add x-shift for this frame
	move.l	d0,(Camera_BG_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG).w
	sub.l	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w
+
	rts
; End of function SetHorizScrollFlagsBG


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D938: ;Vertical_Bg_Deformation1:
SetVertiScrollFlagsBG:		;	used by WFZ, HTZ, HPZ, ARZ
	move.l	(Camera_BG_Y_pos).w,d3
	move.l	d3,d0
	add.l	d5,d0	; add y-shift for this frame

;loc_D940: ;Vertical_Bg_Deformation2:
SetVertiScrollFlagsBG2:
	move.l	d0,(Camera_BG_Y_pos).w
	; What this does is set a specific bit in `Scroll_flags_BG`
	; every time the background crosses a vertical 16-pixel boundary
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Verti_block_crossed_flag_BG).w,d2
	eor.b	d2,d1
	bne.s	++	; rts

	eori.b	#$10,(Verti_block_crossed_flag_BG).w
	sub.l	d3,d0
	bpl.s	+
	; Background has moved down
	bset	d6,(Scroll_flags_BG).w
	rts
; ===========================================================================
+
	; Background has moved up
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w
+
	rts
; End of function SetVertiScrollFlagsBG


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D96C: ;ARZ_Bg_Deformation:
SetHorizScrollFlagsBG_ARZ:	; only used by ARZ
	move.l	(Camera_ARZ_BG_X_pos).w,d0
	add.l	d4,d0
	move.l	d0,(Camera_ARZ_BG_X_pos).w
	lea	(Camera_BG_X_pos).w,a1
	move.w	(a1),d2
	move.w	(Camera_ARZ_BG_X_pos).w,d0
	sub.w	d2,d0
	blo.s	+	; Background has moved to the right
	bhi.s	++	; Background has moved to the left
	rts
; ===========================================================================
+
	; Limit the background's scrolling speed (my guess is that
	; the game can't load more than one column of blocks per frame)
	cmpi.w	#-16,d0
	bgt.s	++
	move.w	#-16,d0
	bra.s	++
; ===========================================================================
+
	cmpi.w	#16,d0
	blo.s	+
	move.w	#16,d0
+
	add.w	(a1),d0
	move.w	d0,(a1)
	move.w	d0,d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG).w
	sub.w	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w
+
	rts
; End of function SetHorizScrollFlagsBG_ARZ


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D9C8: ;CPZ_Bg_Deformation:
SetHorizScrollFlagsBG2:	; only used by CPZ
	move.l	(Camera_BG2_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0
	move.l	d0,(Camera_BG2_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG2).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG2).w
	sub.l	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG2).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG2).w
+
	rts
; End of function SetHorizScrollFlagsBG2

; ===========================================================================
; some apparently unused code
;SetHorizScrollFlagsBG3:
	move.l	(Camera_BG3_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0
	move.l	d0,(Camera_BG3_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG3).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG3).w
	sub.l	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG3).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG3).w
+
	rts
; ===========================================================================
; Unused - dead code leftover from S1:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Scroll_flags_BG).w,a2
	lea	(Camera_BG_X_pos).w,a3
	lea	(Level_Layout+$80).w,a4
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
	bsr.w	Draw_BG1
	lea	(Scroll_flags_BG2).w,a2
	lea	(Camera_BG2_X_pos).w,a3
	bra.w	Draw_BG2

; ===========================================================================




; ---------------------------------------------------------------------------
; Subroutine to display correct tiles as you move
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; loc_DA5C:
LoadTilesAsYouMove:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Scroll_flags_BG_copy).w,a2
	lea	(Camera_BG_copy).w,a3
	lea	(Level_Layout+$80).w,a4	; first background line
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
	bsr.w	Draw_BG1

	lea	(Scroll_flags_BG2_copy).w,a2	; referred to in CPZ deformation routine, but cleared right after
	lea	(Camera_BG2_copy).w,a3
	bsr.w	Draw_BG2	; Essentially unused, though

	lea	(Scroll_flags_BG3_copy).w,a2
	lea	(Camera_BG3_copy).w,a3
	bsr.w	Draw_BG3	; used in CPZ deformation routine

	tst.w	(Two_player_mode).w
	beq.s	+
	lea	(Scroll_flags_copy_P2).w,a2
	lea	(Camera_P2_copy).w,a3	; second player camera
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)>>16,d2
	bsr.w	Draw_FG_P2

+
	lea	(Scroll_flags_copy).w,a2
	lea	(Camera_RAM_copy).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)>>16,d2

	tst.b	(Screen_redraw_flag).w
	beq.s	Draw_FG

	move.b	#0,(Screen_redraw_flag).w

	moveq	#-16,d4	; X (relative to camera)
	moveq	#(1+224/16+1)-1,d6 ; Cover the screen, plus an extra row at the top and bottom.
; loc_DACE:
Draw_All:
	; Redraw the whole screen.
	movem.l	d4-d6,-(sp)
	moveq	#-16,d5	; X (relative)
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#-16,d5	; X (relative)
	bsr.w	DrawBlockRow	; draw the current row
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4		; move onto the next row
	dbf	d6,Draw_All	; repeat for all rows

	move.b	#0,(Scroll_flags_copy).w

	rts
; ===========================================================================
; loc_DAF6:
Draw_FG:
	tst.b	(a2)		; is any scroll flag set?
	beq.s	return_DB5A	; if not, branch

	bclr	#scroll_flag_fg_up,(a2)	; has the level scrolled up?
	beq.s	+			; if not, branch
	moveq	#-16,d4
	moveq	#-16,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4
	moveq	#-16,d5
	bsr.w	DrawBlockRow	; redraw upper row
+
	bclr	#scroll_flag_fg_down,(a2)	; has the level scrolled down?
	beq.s	+			; if not, branch
	move.w	#224,d4
	moveq	#-16,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#224,d4
	moveq	#-16,d5
	bsr.w	DrawBlockRow	; redraw bottom row
+
	bclr	#scroll_flag_fg_left,(a2)	; has the level scrolled to the left?
	beq.s	+			; if not, branch
	moveq	#-16,d4
	moveq	#-16,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4
	moveq	#-16,d5
	bsr.w	DrawBlockColumn	; redraw left-most column
+
	bclr	#scroll_flag_fg_right,(a2)	; has the level scrolled to the right?
	beq.s	return_DB5A		; if not, return
	moveq	#-16,d4
	move.w	#320,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4
	move.w	#320,d5
	bsr.w	DrawBlockColumn	; redraw right-most column

return_DB5A:
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DB5C:
Draw_FG_P2:
	tst.b	(a2)
	beq.s	return_DBC0

	bclr	#scroll_flag_fg_up,(a2)
	beq.s	+
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_fg_down,(a2)
	beq.s	+
	move.w	#224,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	#224,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_fg_left,(a2)
	beq.s	+
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	DrawBlockColumn
+
	bclr	#scroll_flag_fg_right,(a2)
	beq.s	return_DBC0
	moveq	#-16,d4	; Y offset
	move.w	#320,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	moveq	#-16,d4	; Y offset
	move.w	#320,d5	; X offset
	bsr.w	DrawBlockColumn

return_DBC0:
	rts
; End of function Draw_FG_P2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DBC2:
Draw_BG1:
	tst.b	(a2)
	beq.w	return_DC90

	bclr	#scroll_flag_bg1_up,(a2)
	beq.s	+
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_bg1_down,(a2)
	beq.s	+
	move.w	#224,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#224,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_bg1_left,(a2)
	beq.s	+
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	DrawBlockColumn
+
	bclr	#scroll_flag_bg1_right,(a2)
	beq.s	+
	moveq	#-16,d4	; Y offset
	move.w	#320,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4	; Y offset
	move.w	#320,d5	; X offset
	bsr.w	DrawBlockColumn
+
	bclr	#scroll_flag_bg1_up_whole_row,(a2)
	beq.s	+
	moveq	#-16,d4		; Y offset
	moveq	#0,d5		; X (absolute)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	moveq	#-16,d4
	moveq	#0,d5
	moveq	#512/16-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth
+
	bclr	#scroll_flag_bg1_down_whole_row,(a2)
	beq.s	+
	move.w	#224,d4		; Y offset
	moveq	#0,d5		; X (absolute)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	move.w	#224,d4
	moveq	#0,d5
	moveq	#512/16-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth
+
	; This should be no different than 'scroll_flag_bg1_up_whole_row'.
	; The only difference between the two is that this has a relative X
	; coordinate, but that doesn't matter since the entire row is copied
	; anyway.
	bclr	#scroll_flag_bg1_up_whole_row_2,(a2)
	beq.s	+
	moveq	#-16,d4		; Y offset (relative to camera)
	moveq	#-16,d5		; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-16,d4
	moveq	#-16,d5
	moveq	#512/16-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow_CustomWidth
+
	; This should be no different than 'scroll_flag_bg1_down_whole_row'.
	; The only difference between the two is that this has a relative X
	; coordinate, but that doesn't matter since the entire row is copied
	; anyway.
	bclr	#scroll_flag_bg1_down_whole_row_2,(a2)
	beq.s	return_DC90
	move.w	#224,d4		; Y offset (relative to camera)
	moveq	#-16,d5		; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#224,d4
	moveq	#-16,d5
	moveq	#512/16-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow_CustomWidth

return_DC90:
	rts
; End of function Draw_BG1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DC92:
Draw_BG2:
	tst.b	(a2)
	beq.w	++	; rts

	; Leftover from Sonic 1: was used by Green Hill Zone and Spring Yard Zone.
	bclr	#scroll_flag_bg2_left,(a2)
	beq.s	+
	move.w	#112,d4	; Y offset
	moveq	#-16,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#112,d4	; Y offset
	moveq	#-16,d5	; X offset
	moveq	#3-1,d6	; Only three blocks, which works out to 48 pixels in height.
	bsr.w	DrawBlockColumn.CustomHeight
+
	bclr	#scroll_flag_bg2_right,(a2)
	beq.s	+
	move.w	#112,d4	; Y offset
	move.w	#320,d5		; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#112,d4	; Y offset
	move.w	#320,d5	; X offset
	moveq	#3-1,d6	; Only three blocks, which works out to 48 pixels in height.
	bsr.w	DrawBlockColumn.CustomHeight
+
	rts
; End of function Draw_BG2

; ===========================================================================
; Scrap Brain Zone 1 block positioning array -- S1 left-over
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. A entry of 0 means assume X = 0 for section,
; but otherwise loads camera Y for selected camera.
; Note that this list is 32 blocks long, which is enough to span the entire
; two-chunk-tall background.
;byte_DCD6
SBZ_CameraSections:
	; BG1 (draw whole row)
	dc.b 0	; 0
	dc.b 0	; 1
	dc.b 0	; 2
	dc.b 0	; 3
	dc.b 0	; 4
	; BG3
	dc.b 6	; 5
	dc.b 6	; 6
	dc.b 6	; 7
	dc.b 6	; 8
	dc.b 6	; 9
	dc.b 6	; 10
	dc.b 6	; 11
	dc.b 6	; 12
	dc.b 6	; 13
	dc.b 6	; 14
	; BG2
	dc.b 4	; 15
	dc.b 4	; 16
	dc.b 4	; 17
	dc.b 4	; 18
	dc.b 4	; 19
	dc.b 4	; 20
	dc.b 4	; 21
	; BG1
	dc.b 2	; 22
	dc.b 2	; 23
	dc.b 2	; 24
	dc.b 2	; 25
	dc.b 2	; 26
	dc.b 2	; 27
	dc.b 2	; 28
	dc.b 2	; 29
	dc.b 2	; 30
	dc.b 2	; 31
	dc.b 2	; 32

	; Total height: 2 256x256 chunks.
	; This matches the height of the background.

	even

; ===========================================================================
	; Scrap Brain Zone 1 drawing code -- Sonic 1 left-over.

;Draw_BG2_SBZ:
	; Chemical Plant Zone uses a lighty-modified version this code.
	; This is an advanced form of the usual background-drawing code that
	; allows each row of blocks to update and scroll independently...
	; kind of. There are only three possible 'cameras' that each row can
	; align itself with. Still, each row is free to decide which camera
	; it aligns with.
	; This could have really benefitted Oil Ocean Zone's background,
	; which has a section that goes unseen because the regular background
	; drawer is too primitive to display it without making the sun and
	; clouds disappear. Using this would have avoided that.

	; Handle loading the rows as the camera moves up and down.
	moveq	#-16,d4	; Y offset (relative to camera)
	bclr	#scroll_flag_advanced_bg_up,(a2)
	bne.s	.doUpOrDown
	bclr	#scroll_flag_advanced_bg_down,(a2)
	beq.s	.checkIfShouldDoLeftOrRight
	move.w	#224,d4	; Y offset (relative to camera)

.doUpOrDown:
	lea_	SBZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since SBZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	lea	(BGCameraLookup).l,a3
	movea.w	(a3,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	beq.s	.doWholeRow
	moveq	#-16,d5	; X offset (relative to camera)
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow
	bra.s	.checkIfShouldDoLeftOrRight
; ===========================================================================

.doWholeRow:
	moveq	#0,d5	; X (absolute)
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	movem.l	(sp)+,d4-d5
	moveq	#512/16-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth

.checkIfShouldDoLeftOrRight:
	; If there are other scroll flags set, then go do them.
	tst.b	(a2)
	bne.s	.doLeftOrRight
	rts
; ===========================================================================

.doLeftOrRight:
	moveq	#-16,d4 ; Y offset

	; Load left column.
	moveq	#-16,d5 ; X offset
	move.b	(a2),d0
	andi.b	#(1<<scroll_flag_advanced_bg1_right)|(1<<scroll_flag_advanced_bg2_right)|(1<<scroll_flag_advanced_bg3_right),d0
	beq.s	+
	lsr.b	#1,d0	; Make the left and right flags share the same bits, to simplify a calculation later.
	move.b	d0,(a2)
	; Load right column.
	move.w	#320,d5 ; X offset
+
	; Select the correct starting background section, and then begin
	; drawing the column.
	lea_	SBZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since SBZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	DrawBlockColumn_Advanced
; end unused routine

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DD82:
Draw_BG3:
	tst.b	(a2)
	beq.w	++	; rts

	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.w	Draw_BG3_CPZ
    if fixBugs
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	beq.w	Draw_BG3_OOZ
    endif

	; Leftover from Sonic 1: was used by Green Hill Zone.
	bclr	#scroll_flag_bg3_left,(a2)
	beq.s	+
	move.w	#64,d4	; Y offset (relative to camera)
	moveq	#-16,d5	; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#64,d4	; Y offset (relative to camera)
	moveq	#-16,d5	; X offset (relative to camera)
	moveq	#3-1,d6
	bsr.w	DrawBlockColumn.CustomHeight
+
	bclr	#scroll_flag_bg3_right,(a2)
	beq.s	+
	move.w	#64,d4	; Y offset (relative to camera)
	move.w	#320,d5	; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#64,d4	; Y offset (relative to camera)
	move.w	#320,d5	; X offset (relative to camera)
	moveq	#3-1,d6
	bsr.w	DrawBlockColumn.CustomHeight
+
	rts
; ===========================================================================
; Chemical Plant Zone block positioning array
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. Unlike the Scrap Brain Zone version, 0
; does not make X = 0: it's just a duplicate of 2.
;byte_DDD0
CPZ_CameraSections:
	; BG1
	dc.b 2	; 0
	dc.b 2	; 1
	dc.b 2	; 2
	dc.b 2	; 3
	dc.b 2	; 4
	dc.b 2	; 5
	dc.b 2	; 6
	dc.b 2	; 7
	dc.b 2	; 8
	dc.b 2	; 9
	dc.b 2	; 10
	dc.b 2	; 11
	dc.b 2	; 12
	dc.b 2	; 13
	dc.b 2	; 14
	dc.b 2	; 15
	dc.b 2	; 16
	dc.b 2	; 17
	dc.b 2	; 18
	dc.b 2	; 19
	; BG2
	dc.b 4	; 20
	dc.b 4	; 21
	dc.b 4	; 22
	dc.b 4	; 23
	dc.b 4	; 24
	dc.b 4	; 25
	dc.b 4	; 26
	dc.b 4	; 27
	dc.b 4	; 28
	dc.b 4	; 29
	dc.b 4	; 30
	dc.b 4	; 31
	dc.b 4	; 32
	dc.b 4	; 33
	dc.b 4	; 34
	dc.b 4	; 35
	dc.b 4	; 36
	dc.b 4	; 37
	dc.b 4	; 38
	dc.b 4	; 39
	dc.b 4	; 40
	dc.b 4	; 41
	dc.b 4	; 42
	dc.b 4	; 43
	dc.b 4	; 44
	dc.b 4	; 45
	dc.b 4	; 46
	dc.b 4	; 47
	dc.b 4	; 48
	dc.b 4	; 49
	dc.b 4	; 50
	dc.b 4	; 51
	dc.b 4	; 52
	dc.b 4	; 53
	dc.b 4	; 54
	dc.b 4	; 55
	dc.b 4	; 56
	dc.b 4	; 57
	dc.b 4	; 58
	dc.b 4	; 59
	dc.b 4	; 60
	dc.b 4	; 61
	dc.b 4	; 62
	dc.b 4	; 63
	dc.b 4	; 64

	; Total height: 8 128x128 chunks.
	; CPZ's background is only 7 chunks tall, but extending to
	; 8 is necessary for wrapping to be achieved using bitmasks.

	even

; ===========================================================================
; loc_DE12:
Draw_BG3_CPZ:
	; This is a lighty-modified duplicate of Scrap Brain Zone's drawing
	; code (which is still in this game - it's labelled 'Draw_BG2_SBZ').
	; This is an advanced form of the usual background-drawing code that
	; allows each row of blocks to update and scroll independently...
	; kind of. There are only three possible 'cameras' that each row can
	; align itself with. Still, each row is free to decide which camera
	; it aligns with.
	; This could have really benefitted Oil Ocean Zone's background,
	; which has a section that goes unseen because the regular background
	; drawer is too primitive to display it without making the sun and
	; clouds disappear. Using this would have avoided that.
	; This code differs from the Scrap Brain Zone version by being
	; hardcoded to a different table ('CPZ_CameraSections' instead of
	; 'SBZ_CameraSections'), and lacking support for redrawing the whole
	; row when it uses "camera 0".

	; Handle loading the rows as the camera moves up and down.
	moveq	#-16,d4	; Y offset
	bclr	#scroll_flag_advanced_bg_up,(a2)
	bne.s	.doUpOrDown
	bclr	#scroll_flag_advanced_bg_down,(a2)
	beq.s	.checkIfShouldDoLeftOrRight
	move.w	#224,d4	; Y offset

.doUpOrDown:
	; Select the correct camera, so that the X value of the loaded row is
	; right.
	lea_	CPZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$3F0,d0	; After right-shifting, the is a mask of $3F. Since CPZ_CameraSections is $40 items long, this is correct.
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	moveq	#-16,d5	; X offset
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow

.checkIfShouldDoLeftOrRight:
	; If there are other scroll flags set, then go do them.
	tst.b	(a2)
	bne.s	.doLeftOrRight
	rts
; ===========================================================================

.doLeftOrRight:
	moveq	#-16,d4 ; Y offset

	; Load left column.
	moveq	#-16,d5 ; X offset
	move.b	(a2),d0
	andi.b	#(1<<scroll_flag_advanced_bg1_right)|(1<<scroll_flag_advanced_bg2_right)|(1<<scroll_flag_advanced_bg3_right),d0
	beq.s	+
	lsr.b	#1,d0	; Make the left and right flags share the same bits, to simplify a calculation later.
	move.b	d0,(a2)
	; Load right column.
	move.w	#320,d5 ; X offset
+
	; Select the correct starting background section, and then begin
	; drawing the column.
	lea_	CPZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
    if fixBugs
	andi.w	#$3F0,d0	; After right-shifting, the is a mask of $3F. Since CPZ_CameraSections is $40 items long, this is correct.
    endif
	; After right-shifting, the is a mask of $7F. Since CPZ_CameraSections
	; is $40 items long, this is incorrect, and will cause accesses to
	; exceed the bounds of CPZ_CameraSections and read invalid data. This
	; is most notably a problem in Marble Zone's version of this code.
	andi.w	#$7F0,d0
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	DrawBlockColumn_Advanced
; ===========================================================================
;word_DE7E
BGCameraLookup:
	dc.w Camera_BG_copy	; BG Camera
	dc.w Camera_BG_copy	; BG Camera
	dc.w Camera_BG2_copy	; BG2 Camera
	dc.w Camera_BG3_copy	; BG3 Camera
; ===========================================================================
; loc_DE86:
DrawBlockColumn_Advanced:
	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

	moveq	#(1+224/16+1)-1,d6	; Enough blocks to cover the screen, plus one more on the top and bottom.
	move.l	#vdpCommDelta($0080),d7

-
	; If the block is not part of the row that needs updating, then skip
	; drawing it.
	moveq	#0,d0
	move.b	(a0)+,d0
	btst	d0,(a2)
	beq.s	+

	; Get the correct camera and draw this block.
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	movem.l	d4-d5/a0,-(sp)
	movem.l	d4-d5,-(sp)
	bsr.w	GetBlock
	movem.l	(sp)+,d4-d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	bsr.w	ProcessAndWriteBlock_Vertical
	movem.l	(sp)+,d4-d5/a0
+
	; Move onto the next block down.
	addi.w	#16,d4
	dbf	d6,-

	; Clear the scroll flags now that we're done here.
	clr.b	(a2)

	rts
; ===========================================================================

.doubleResolution:
	moveq	#(1+224/16+1)-1,d6	; Enough blocks to cover the screen, plus one more on the top and bottom.
	move.l	#vdpCommDelta($0080),d7

-
	; If the block is not part of the row that needs updating, then skip
	; drawing it.
	moveq	#0,d0
	move.b	(a0)+,d0
	btst	d0,(a2)
	beq.s	+

	; Get the correct camera and draw this block.
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	movem.l	d4-d5/a0,-(sp)
	movem.l	d4-d5,-(sp)
	bsr.w	GetBlock
	movem.l	(sp)+,d4-d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Vertical
	movem.l	(sp)+,d4-d5/a0
+
	; Move onto the next block down.
	addi.w	#16,d4
	dbf	d6,-

	; Clear the scroll flags now that we're done here.
	clr.b	(a2)

	rts
; End of function Draw_BG3


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
    if fixBugs
	; See 'SwScrl_OOZ'.
	; This uses the same drawing method as Chemical Plant Zone to enable
	; the unused part of Oil Ocean Zone's background to be drawn without
	; it causing the clouds and sun to disappear.

; Oil Ocean Zone block positioning array
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. A entry of 0 means assume X = 0 for section,
; but otherwise loads camera Y for selected camera.

OOZ_CameraSections:
	; BG1 (draw whole row) for the sky.
	dc.b 0	; 0
	dc.b 0	; 1
	dc.b 0	; 2
	dc.b 0	; 3
	dc.b 0	; 4
	dc.b 0	; 5
	dc.b 0	; 6
	dc.b 0	; 7
	dc.b 0	; 8
	dc.b 0	; 9
	dc.b 0	; 10
	dc.b 0	; 11
	dc.b 0	; 12
	dc.b 0	; 13
	dc.b 0	; 14
	dc.b 0	; 15
	dc.b 0	; 16
	; BG1 for the factory.
	dc.b 2	; 17
	dc.b 2	; 18
	dc.b 2	; 19
	dc.b 2	; 20
	dc.b 2	; 21
	dc.b 2	; 22
	dc.b 2	; 23
	dc.b 2	; 24
	dc.b 2	; 25
	dc.b 2	; 26
	dc.b 2	; 27
	dc.b 2	; 28
	dc.b 2	; 29
	dc.b 2	; 30
	dc.b 2	; 31
	dc.b 2	; 32

	; Total height: 4 128x128 chunks.
	; This matches the height of the background.

	even

; ===========================================================================

Draw_BG3_OOZ:
	; This is a lighty-modified duplicate of Scrap Brain Zone's drawing
	; code (which is still in this game - it's labelled 'Draw_BG2_SBZ').
	; This is an advanced form of the usual background-drawing code that
	; allows each row of blocks to update and scroll independently...
	; kind of. There are only three possible 'cameras' that each row can
	; align itself with. Still, each row is free to decide which camera
	; it aligns with.

	; Handle loading the rows as the camera moves up and down.
	moveq	#-16,d4	; Y offset
	bclr	#scroll_flag_advanced_bg_up,(a2)
	bne.s	.doUpOrDown
	bclr	#scroll_flag_advanced_bg_down,(a2)
	beq.s	.checkIfShouldDoLeftOrRight
	move.w	#224,d4	; Y offset

.doUpOrDown:
	; Select the correct camera, so that the X value of the loaded row is
	; right.
	lea_	OOZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since OOZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	lea	BGCameraLookup(pc),a3
	movea.w	(a3,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	beq.s	.doWholeRow
	moveq	#-16,d5	; X offset
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow
	bra.s	.checkIfShouldDoLeftOrRight
; ===========================================================================

.doWholeRow:
	moveq	#0,d5	; X (absolute)
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	movem.l	(sp)+,d4-d5
	moveq	#512/16-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth

.checkIfShouldDoLeftOrRight:
	; If there are other scroll flags set, then go do them.
	tst.b	(a2)
	bne.s	.doLeftOrRight
	rts
; ===========================================================================

.doLeftOrRight:
	moveq	#-16,d4 ; Y offset

	; Load left column.
	moveq	#-16,d5 ; X offset
	move.b	(a2),d0
	andi.b	#(1<<scroll_flag_advanced_bg1_right)|(1<<scroll_flag_advanced_bg2_right)|(1<<scroll_flag_advanced_bg3_right),d0
	beq.s	+
	lsr.b	#1,d0	; Make the left and right flags share the same bits, to simplify a calculation later.
	move.b	d0,(a2)
	; Load right column.
	move.w	#320,d5 ; X offset
+
	; Select the correct starting background section, and then begin
	; drawing the column.
	lea_	OOZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since OOZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	DrawBlockColumn_Advanced
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF04: DrawBlockCol1:
DrawBlockColumn:
	moveq	#(1+224/16+1)-1,d6 ; Enough blocks to cover the screen, plus one more on the top and bottom.
; DrawBlockCol2:
.CustomHeight:
	add.w	(a3),d5		; add camera X pos
	add.w	4(a3),d4	; add camera Y pos
	move.l	#vdpCommDelta(64*2),d7	; store VDP command for line increment
	move.l	d0,d1		; copy byte-swapped VDP command for later access
	bsr.w	GetAddressOfBlockInChunk

	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

-	move.w	(a0),d3		; get ID of the 16x16 block
	andi.w	#$3FF,d3
	lsl.w	#3,d3		; multiply by 8, the size in bytes of a 16x16
	lea	(Block_Table).w,a1
	adda.w	d3,a1		; a1 = address of the current 16x16 in the block table
	move.l	d1,d0
	bsr.w	ProcessAndWriteBlock_Vertical
	adda.w	#128/16*2,a0	; move onto the 16x16 vertically below this one
	addi.w	#64*2*2,d1	; draw on alternate 8x8 lines
	andi.w	#(64*32*2)-1,d1	; wrap around plane (assumed to be in 64x32 mode)
	addi.w	#16,d4		; add 16 to Y offset
	move.w	d4,d0
	andi.w	#$70,d0		; have we reached a new 128x128?
	bne.s	+		; if not, branch
	bsr.w	GetAddressOfBlockInChunk	; otherwise, renew the block address
+	dbf	d6,-		; repeat 16 times

	rts
; ===========================================================================

.doubleResolution:
-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	move.l	d1,d0
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Vertical
	adda.w	#128/16*2,a0
	addi.w	#$80,d1
	andi.w	#(64*32*2)-1,d1
	addi.w	#16,d4
	move.w	d4,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetAddressOfBlockInChunk
+	dbf	d6,-

	rts
; End of function DrawBlockColumn


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF8A: DrawTiles_Vertical: DrawBlockRow:
DrawBlockRow_CustomWidth:
	add.w	(a3),d5
	add.w	4(a3),d4
	bra.s	DrawBlockRow.AbsoluteXAbsoluteYCustomWidth
; End of function DrawBlockRow_CustomWidth


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF92: DrawTiles_Vertical1: DrawBlockRow1:
DrawBlockRow:
	moveq	#(1+320/16+1)-1,d6 ; Just enough blocks to cover the screen.
	add.w	(a3),d5		; add X pos
; loc_DF96: DrawTiles_Vertical2: DrawBlockRow2:
.AbsoluteXCustomWidth:
	add.w	4(a3),d4	; add Y pos
; loc_DF9A: DrawTiles_Vertical3: DrawBlockRow3:
.AbsoluteXAbsoluteYCustomWidth:
	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

	move.l	a2,-(sp)
	move.w	d6,-(sp)
	lea	(Block_cache).w,a2
	move.l	d0,d1
	or.w	d2,d1
	swap	d1		; make VRAM write command
	move.l	d1,-(sp)
	move.l	d1,(a5)		; set up a VRAM write at that address
	swap	d1
	bsr.w	GetAddressOfBlockInChunk

-	move.w	(a0),d3		; get ID of the 16x16 block
	andi.w	#$3FF,d3
	lsl.w	#3,d3		; multiply by 8, the size in bytes of a 16x16
	lea	(Block_Table).w,a1
	adda.w	d3,a1		; a1 = address of current 16x16 in the block table
	bsr.w	ProcessAndWriteBlock_Horizontal
	addq.w	#2,a0		; move onto next 16x16
	addq.b	#4,d1		; increment VRAM write address
	bpl.s	+
	andi.b	#$7F,d1		; restrict to a single 8x8 line
	swap	d1
	move.l	d1,(a5)		; set up a VRAM write at a new address
	swap	d1
+
	addi.w	#16,d5		; add 16 to X offset
	move.w	d5,d0
	andi.w	#$70,d0		; have we reached a new 128x128?
	bne.s	+		; if not, branch
	bsr.w	GetAddressOfBlockInChunk	; otherwise, renew the block address
+
	dbf	d6,-		; repeat 22 times

	move.l	(sp)+,d1
	addi.l	#vdpCommDelta(64*2),d1	; move onto next line
	lea	(Block_cache).w,a2
	move.l	d1,(a5)		; write to this VRAM address
	swap	d1
	move.w	(sp)+,d6

-	move.l	(a2)+,(a6)	; write stored 8x8s
	addq.b	#4,d1		; increment VRAM write address
	bmi.s	+
	ori.b	#$80,d1		; force to bottom 8x8 line
	swap	d1
	move.l	d1,(a5)		; set up a VRAM write at a new address
	swap	d1
+
	dbf	d6,-		; repeat 22 times

	movea.l	(sp)+,a2
	rts
; ===========================================================================
; loc_E018: DrawBlockRow_2P:
.doubleResolution:
	move.l	d0,d1
	or.w	d2,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
	tst.b	d1
	bmi.s	+++

	bsr.w	GetAddressOfBlockInChunk

-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Horizontal
	addq.w	#2,a0
	addq.b	#4,d1
	bpl.s	+
	andi.b	#$7F,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
+
	addi.w	#16,d5
	move.w	d5,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetAddressOfBlockInChunk
+	dbf	d6,-

	rts
; ===========================================================================
+
	bsr.w	GetAddressOfBlockInChunk

-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Horizontal
	addq.w	#2,a0
	addq.b	#4,d1
	bmi.s	+
	ori.b	#$80,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
+
	addi.w	#16,d5
	move.w	d5,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetAddressOfBlockInChunk
+	dbf	d6,-

	rts
; End of function DrawBlockRow


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E09E: GetBlockAddr:
GetAddressOfBlockInChunk:
	movem.l	d4-d5,-(sp)
	move.w	d4,d3		; d3 = camera Y pos + offset
	add.w	d3,d3
	andi.w	#$F00,d3	; limit to units of $100 ($100 = size of a row of FG and BG 128x128s in level layout table)
	lsr.w	#3,d5		; divide by 8
	move.w	d5,d0
	lsr.w	#4,d0		; divide by 16 (overall division of 128)
	andi.w	#$7F,d0
	add.w	d3,d0		; get offset of current 128x128 in the level layout table
	moveq	#-1,d3
	clr.w	d3		; d3 = $FFFF0000
	move.b	(a4,d0.w),d3	; get tile ID of the current 128x128 tile
	lsl.w	#7,d3		; multiply by 128, the size in bytes of a 128x128 in RAM
	andi.w	#$70,d4		; round down to nearest 16-pixel boundary
	andi.w	#$E,d5		; force this to be a multiple of 16
	add.w	d4,d3		; add vertical offset of current 16x16
	add.w	d5,d3		; add horizontal offset of current 16x16
	movea.l	d3,a0		; store address, in the metablock table, of the current 16x16
	movem.l	(sp)+,d4-d5
	rts
; End of function GetAddressOfBlockInChunk


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E0D4: ProcessAndWriteBlock:
ProcessAndWriteBlock_Horizontal:
	; Compared to 'ProcessAndWriteBlock_Vertical', this caches the bottom
	; two tiles far later writing. This avoids the need to constantly
	; alternate VRAM destinations.
	btst	#3,(a0)		; is this 16x16 to be Y-flipped?
	bne.s	.flipY		; if it is, branch
	btst	#2,(a0)		; is this 16x16 to be X-flipped?
	bne.s	.flipX		; if it is, branch
	move.l	(a1)+,(a6)	; write top two 8x8s to VRAM
	move.l	(a1)+,(a2)+	; store bottom two 8x8s for later writing
	rts
; ===========================================================================
; ProcessAndWriteBlock_FlipX:
.flipX:
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3	; toggle X-flip flag of the 8x8s
	swap	d3		; swap the position of the 8x8s
	move.l	d3,(a6)		; write top two 8x8s to VRAM
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a2)+	; store bottom two 8x8s for later writing
	rts
; ===========================================================================
; ProcessAndWriteBlock_FlipY:
.flipY:
	btst	#2,(a0)		; is this 16x16 to be X-flipped as well?
	bne.s	.flipXY		; if it is, branch
	move.l	(a1)+,d0
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3	; toggle Y-flip flag of the 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s to VRAM
	eori.l	#(flip_y<<16)|flip_y,d0
	move.l	d0,(a2)+	; store top two 8x8s for later writing
	rts
; ===========================================================================
; ProcessAndWriteBlock_FlipXY:
.flipXY:
	move.l	(a1)+,d0
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3	; toggle X and Y-flip flags of the 8x8s
	swap	d3
	move.l	d3,(a6)		; write bottom two 8x8s to VRAM
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d0
	swap	d0
	move.l	d0,(a2)+	; store top two 8x8s for later writing
	rts
; End of function ProcessAndWriteBlock_Horizontal


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_E136: ProcessAndWriteBlock_2P:
ProcessAndWriteBlock_DoubleResolution_Horizontal:
	; In two player mode, the VDP's Interlace Mode 2 is enabled, making
	; tiles twice as tall (16x8 instead of 8x8). Because of this, blocks
	; are now composed of only two tiles, arranged side by side.
	btst	#3,(a0)
	bne.s	.flipY
	btst	#2,(a0)
	bne.s	.flipX
	move.l	(a1)+,(a6)
	rts
; ===========================================================================
; loc_E146:
.flipX:
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)
	rts
; ===========================================================================
; loc_E154:
.flipY:
	btst	#2,(a0)
	bne.s	.flipXY
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3
	move.l	d3,(a6)
	rts
; ===========================================================================
;loc_E166:
.flipXY:
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3
	swap	d3
	move.l	d3,(a6)
	rts
; End of function ProcessAndWriteBlock_DoubleResolution_Horizontal


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E174: ProcessAndWriteBlock2:
ProcessAndWriteBlock_Vertical:
	or.w	d2,d0
	swap	d0		; make VRAM write command
	btst	#3,(a0)		; is the 16x16 to be Y-flipped?
	bne.s	.flipY		; if it is, branch
	btst	#2,(a0)		; is the 16x16 to be X-flipped?
	bne.s	.flipX		; if it is, branch
	move.l	d0,(a5)		; write to this VRAM address
	move.l	(a1)+,(a6)	; write top two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	move.l	(a1)+,(a6)	; write bottom two 8x8s
	rts
; ===========================================================================
; ProcessAndWriteBlock2_FlipX:
.flipX:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3	; toggle X-flip flag of the 8x8s
	swap	d3		; swap the position of the 8x8s
	move.l	d3,(a6)		; write top two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)		; write bottom two 8x8s
	rts
; ===========================================================================
; ProcessAndWriteBlock2_FlipY:
.flipY:
	btst	#2,(a0)		; is the 16x16 to be X-flipped as well?
	bne.s	.flipXY		; if it is, branch
	move.l	d5,-(sp)
	move.l	d0,(a5)
	move.l	(a1)+,d5
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3	; toggle Y-flip flag of 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	eori.l	#(flip_y<<16)|flip_y,d5
	move.l	d5,(a6)		; write top two 8x8s
	move.l	(sp)+,d5
	rts
; ===========================================================================
;ProcessAndWriteBlock2_FlipXY:
.flipXY:
	move.l	d5,-(sp)
	move.l	d0,(a5)
	move.l	(a1)+,d5
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3	; toggle X and Y-flip flags of 8x8s
	swap	d3		; swap the position of the 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s
	add.l	d7,d0
	move.l	d0,(a5)
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d5
	swap	d5
	move.l	d5,(a6)		; write top two 8x8s
	move.l	(sp)+,d5
	rts
; End of function ProcessAndWriteBlock_Vertical


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_E1FA: ProcessAndWriteBlock2_2P:
ProcessAndWriteBlock_DoubleResolution_Vertical:
	or.w	d2,d0
	swap	d0
	btst	#3,(a0)
	bne.s	.flipY
	btst	#2,(a0)
	bne.s	.flipX
	move.l	d0,(a5)
	move.l	(a1)+,(a6)
	rts
; ===========================================================================
; loc_E210:
.flipX:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)
	rts
; ===========================================================================
; loc_E220:
.flipY:
	btst	#2,(a0)
	bne.s	.flipXY
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3
	move.l	d3,(a6)
	rts
; ===========================================================================
; loc_E234:
.flipXY:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3
	swap	d3
	move.l	d3,(a6)
	rts
; End of function ProcessAndWriteBlock_DoubleResolution_Vertical


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E244: GetBlockPtr:
GetBlock:
	add.w	(a3),d5
	add.w	4(a3),d4
	lea	(Block_Table).w,a1
	move.w	d4,d3		; d3 = camera Y pos + offset
	add.w	d3,d3
	andi.w	#$F00,d3	; limit to units of $100 ($100 = $80 * 2, $80 = height of a 128x128)
	lsr.w	#3,d5		; divide by 8
	move.w	d5,d0
	lsr.w	#4,d0		; divide by 16 (overall division of 128)
	andi.w	#$7F,d0
	add.w	d3,d0		; get offset of current 128x128 in the level layout table
	moveq	#-1,d3
	clr.w	d3		; d3 = $FFFF0000
	move.b	(a4,d0.w),d3	; get tile ID of the current 128x128 tile
	lsl.w	#7,d3		; multiply by 128, the size in bytes of a 128x128 in RAM
	andi.w	#$70,d4		; round down to nearest 16-pixel boundary
	andi.w	#$E,d5		; force this to be a multiple of 16
	add.w	d4,d3		; add vertical offset of current 16x16
	add.w	d5,d3		; add horizontal offset of current 16x16
	movea.l	d3,a0		; store address, in the metablock table, of the current 16x16
	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	adda.w	d3,a1
	rts
; End of function GetBlock


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E286: Calc_VRAM_Pos: CalcBlockVRAMPos:
CalculateVRAMAddressOfBlockForPlayer1:
	add.w	(a3),d5		; add X pos
; CalcBlockVRAMPos2:
.AbsoluteX:
	tst.w	(Two_player_mode).w
	bne.s	.AbsoluteX_DoubleResolution
	add.w	4(a3),d4	; add Y pos
; CalcBlockVRAMPos_NoCamera:
.AbsoluteXAbsoluteY:
	andi.w	#$F0,d4		; round down to the nearest 16-pixel boundary
	andi.w	#$1F0,d5	; round down to the nearest 16-pixel boundary
	lsl.w	#4,d4		; make it into units of $100 - the height in plane A of a 16x16
	lsr.w	#2,d5		; make it into units of 4 - the width in plane A of a 16x16
	add.w	d5,d4		; combine the two to get final address
	; access a VDP address in plane name table A ($C000) or B ($E000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0		; make word-swapped VDP command
	rts
; ===========================================================================
; loc_E2A8: CalcBlockVRAMPos_2P:
.AbsoluteX_DoubleResolution:
	add.w	4(a3),d4
; loc_E2AC: CalcBlockVRAMPos_2P_NoCamera:
.AbsoluteXAbsoluteY_DoubleResolution:
	andi.w	#$1F0,d4
	andi.w	#$1F0,d5
	lsl.w	#3,d4
	lsr.w	#2,d5
	add.w	d5,d4
	; access a VDP address in plane name table A ($C000) or B ($E000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0
	rts
; End of function CalculateVRAMAddressOfBlockForPlayer1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;loc_E2C2: CalcBlockVRAMPosB:
CalculateVRAMAddressOfBlockForPlayer2:
	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

;.regularResolution:
	add.w	4(a3),d4
	add.w	(a3),d5
	andi.w	#$F0,d4
	andi.w	#$1F0,d5
	lsl.w	#4,d4
	lsr.w	#2,d5
	add.w	d5,d4
	; access a VDP address in 2p plane name table A ($A000) or B ($8000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0
	rts
; ===========================================================================
; interestingly, this subroutine was in the Sonic 1 ROM, unused
.doubleResolution:
	add.w	4(a3),d4
	add.w	(a3),d5
	andi.w	#$1F0,d4
	andi.w	#$1F0,d5
	lsl.w	#3,d4
	lsr.w	#2,d5
	add.w	d5,d4
	; access a VDP address in 2p plane name table A ($A000) or B ($8000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0
	rts
; End of function CalculateVRAMAddressOfBlockForPlayer2

; ===========================================================================
; Loads the background in its initial state into VRAM (plane B).
; Especially important for levels that never re-load the background dynamically
;loc_E300:
DrawInitialBG:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Camera_BG_X_pos).w,a3
	lea	(Level_Layout+$80).w,a4	; background
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
    if fixBugs
	; The purpose of this function is to dynamically load a portion of
	; the background, based on where the BG camera is pointing. This
	; makes plenty of sense for levels that dynamically load their
	; background to Plane B. However, not all levels do this: some are
	; content with just loading their entire (small) background to
	; Plane B and leaving it there, untouched.
	; Unfortunately, that does not mesh well with this function: if the
	; camera is too high or too low, then only part of the background
	; will be properly loaded. This bug most visibly manifests itself in
	; Casino Night Zone Act 1, where the background abruptly cuts off at
	; the bottom.
	; To work around this, an ugly hack was added, to cause the function
	; to load a portion of the background 16 pixels lower than normal.
	; However, this hack applies to both Act 1 AND Act 2, resulting in
	; Act 2's background being cut off at the top.
	; Sonic 3 & Knuckles fixed this problem for good by giving each zone
	; its own background initialisation function (see 'LevelSetup' in the
	; Sonic & Knuckles disassembly). This fix won't go quite that far,
	; but it will give these 'static' backgrounds their own
	; initialisation logic, much like two player Mystic Cave Zone does.
	move.b	(Current_Zone).w,d0
	cmpi.b	#emerald_hill_zone,d0
	beq.w	DrawInitialBG_LoadWholeBackground_512x256
	cmpi.b	#casino_night_zone,d0
	beq.w	DrawInitialBG_LoadWholeBackground_512x256
	cmpi.b	#hill_top_zone,d0
	beq.w	DrawInitialBG_LoadWholeBackground_512x256
    else
	; This is a nasty hack to work around the bug described above.
	moveq	#0,d4
	cmpi.b	#casino_night_zone,(Current_Zone).w
	beq.w	++
    endif
	tst.w	(Two_player_mode).w
	beq.w	+
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	beq.w	DrawInitialBG_LoadWholeBackground_512x512
+
	moveq	#-16,d4
+
	moveq	#256/16-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#0,d5
	moveq	#512/16-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow_CustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

	rts
; ===========================================================================
	; Dead code for initialising the second player's portion of Plane B.
	; I wonder why this is unused?
	moveq	#-16,d4

	moveq	#256/16-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	d1,d4
	moveq	#0,d5
	moveq	#512/16-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow_CustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

	rts
; ===========================================================================
; loc_E396:
DrawInitialBG_LoadWholeBackground_512x512:
	; Mystic Cave Zone loads its entire background at once in two player
	; mode, since the plane is big enough to fit it, unlike in one player
	; mode (512x512 instead of 512x256).
	moveq	#0,d4	; Absolute plane Y coordinate.

	moveq	#512/16-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteXAbsoluteY_DoubleResolution
	move.w	d1,d4
	moveq	#0,d5
	moveq	#512/16-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow.AbsoluteXAbsoluteYCustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

	rts
; ===========================================================================
    if fixBugs
DrawInitialBG_LoadWholeBackground_512x256:
	moveq	#0,d4	; Absolute plane Y coordinate.

	moveq	#256/16-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	; This is just a fancy efficient way of doing 'if true then call this, else call that'.
	pea	+(pc)
	tst.w	(Two_player_mode).w
	beq.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteXAbsoluteY
	bra.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteXAbsoluteY_DoubleResolution
+
	move.w	d1,d4
	moveq	#0,d5
	moveq	#512/16-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow.AbsoluteXAbsoluteYCustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

	rts
    endif
; ===========================================================================

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loadZoneBlockMaps

; Loads block and bigblock mappings for the current Zone.

loadZoneBlockMaps:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(LevelArtPointers).l,a2
	lea	(a2,d0.w),a2
	move.l	a2,-(sp)
	addq.w	#4,a2
	move.l	(a2)+,d0
	andi.l	#$FFFFFF,d0	; pointer to block mappings
	movea.l	d0,a0
	lea	(Block_Table).w,a1
	jsrto	KosDec, JmpTo_KosDec	; load block maps
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	lea	(Block_Table+$980).w,a1
	lea	(BM16_HTZ).l,a0
	jsrto	KosDec, JmpTo_KosDec	; patch for Hill Top Zone block map
+
	tst.w	(Two_player_mode).w
	beq.s	+
	; In 2P mode, adjust the block table to halve the pattern index on each block
	lea	(Block_Table).w,a1

	move.w	#bytesToWcnt(Block_Table_End-Block_Table),d2
-	move.w	(a1),d0		; read an entry
	move.w	d0,d1
	andi.w	#$F800,d0	; filter for upper five bits
	andi.w	#$7FF,d1	; filter for lower eleven bits (patternIndex)
	lsr.w	#1,d1		; halve the pattern index
	or.w	d1,d0		; put the parts back together
	move.w	d0,(a1)+	; change the entry with the adjusted value
	dbf	d2,-
+
	move.l	(a2)+,d0
	andi.l	#$FFFFFF,d0	; pointer to chunk mappings
	movea.l	d0,a0
	lea	(Chunk_Table).l,a1
	jsrto	KosDec, JmpTo_KosDec
	bsr.w	loadLevelLayout
	movea.l	(sp)+,a2	; zone specific pointer in LevelArtPointers
	addq.w	#4,a2
	moveq	#0,d0
	move.b	(a2),d0	; PLC2 ID
	beq.s	+
	jsrto	LoadPLC, JmpTo_LoadPLC
+
	addq.w	#4,a2
	moveq	#0,d0
	move.b	(a2),d0	; palette ID
	jsrto	PalLoad_Now, JmpTo_PalLoad_Now
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


loadLevelLayout:
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#6,d0
	lea	(Off_Level).l,a0
	move.w	(a0,d0.w),d0
	lea	(a0,d0.l),a0
	lea	(Level_Layout).w,a1
	jmpto	KosDec, JmpTo_KosDec
; End of function loadLevelLayout

; ===========================================================================

;loadLevelLayout_Sonic1:
	; This loads level layout data in Sonic 1's format. Curiously, this
	; function has been changed since Sonic 1: in particular, it repeats
	; the rows of the source data to fill the rows of the destination
	; data, which provides some explanation for why so many of Sonic 2's
	; backgrounds are repeated in their layout data. This repeating is
	; needed to prevent Hidden Palace Zone's background from disappearing
	; when the player moves to the left.

	; Clear layout data.
	lea	(Level_Layout).w,a3
	move.w	#bytesToLcnt(Level_Layout_End-Level_Layout),d1
	moveq	#0,d0
-	move.l	d0,(a3)+
	dbf	d1,-

	; The rows of the foreground and background layouts are interleaved
	; in memory. This is done here:
	lea	(Level_Layout).w,a3	; Foreground.
	moveq	#0,d1			; Index into 'Off_Level' to get level foreground layout.
	bsr.w	.loadLayout
	lea	(Level_Layout+$80).w,a3	; Background.
	moveq	#2,d1			; Index into 'Off_Level' to get level background layout.

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E4A2:
.loadLayout:
	; This expects 'Off_Level' to be in the format that it was in
	; Sonic 1.
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#5,d0
	add.w	d1,d0
	lea	(Off_Level).l,a1
	move.w	(a1,d0.w),d0
	lea	(a1,d0.l),a1

	moveq	#0,d1
	move.w	d1,d2
	move.b	(a1)+,d1	; Layout width.
	move.b	(a1)+,d2	; Layout height.
	move.l	d1,d5
	addq.l	#1,d5
	moveq	#0,d3
	move.w	#$80,d3	; Size of layout row in memory.
	divu.w	d5,d3	; Get how many times to repeat the source row to fill the destination row.
	subq.w	#1,d3	; Turn into loop counter.

.nextRow:
	movea.l	a3,a0

	move.w	d3,d4
.repeatRow:
	move.l	a1,-(sp)

	move.w	d1,d0
.nextByte:
	move.b	(a1)+,(a0)+
	dbf	d0,.nextByte

	movea.l	(sp)+,a1
	dbf	d4,.repeatRow

	lea	(a1,d5.w),a1	; Next row in source data.
	lea	$100(a3),a3	; Next row in destination data.
	dbf	d2,.nextRow

	rts
; End of function .loadLayout

; ===========================================================================

;ConvertChunksFrom256x256To128x128:
	; This converts Sonic 1-style 256x256 chunks to Sonic 2-style 128x128
	; chunks.

	; Destination of 128x128 chunks.
	lea	($FE0000).l,a1
	lea	($FE0000+8*8*2).l,a2
	; Source of 256x256 chunks.
	lea	(Chunk_Table).l,a3

	move.w	#64-1,d1	; Process 64 256x256 chunks.
-	bsr.w	ConvertHalfOf256x256ChunkToTwo128x128Chunks
	bsr.w	ConvertHalfOf256x256ChunkToTwo128x128Chunks
	dbf	d1,-

	lea	($FE0000).l,a1
	lea	($FF0000).l,a2

	; Insert a blank chunk at the start of chunk table.
	move.w	#bytesToWcnt(8*8*2),d1
-	move.w	#0,(a2)+
	dbf	d1,-

	; Copy the actual chunks to after this blank chunk.
	move.w	#bytesToWcnt($8000-(8*8*2)),d1
-	move.w	(a1)+,(a2)+
	dbf	d1,-

	rts
; ===========================================================================

;EliminateChunkDuplicates:
	; This is a chunk de-duplicator.

	; Copy first chunk into 'Chunk_Table'.
	lea	($FE0000).l,a1
	lea	(Chunk_Table).l,a3

	moveq	#bytesToLcnt(8*8*2),d0
-	move.l	(a1)+,(a3)+
	dbf	d0,-

	moveq	#0,d7	; This holds how many chunks have been copied minus 1.
	lea	($FE0000).l,a1
	move.w	#$100-1,d5	; $100 chunks
;loc_E55A:
.nextChunk:
	lea	(Chunk_Table).l,a3
	move.w	d7,d6

.doNextComparison:
	movem.l	a1-a3,-(sp)

	; Compare chunks.
	move.w	#bytesToWcnt(8*8*2),d0
-	cmpm.w	(a1)+,(a3)+
	bne.s	+
	dbf	d0,-

	; The chunks match.
	movem.l	(sp)+,a1-a3
	adda.w	#8*8*2,a1
	dbf	d5,.nextChunk

	bra.s	++
; ===========================================================================
+
	; No match: check the next chunk.
	movem.l	(sp)+,a1-a3
	adda.w	#8*8*2,a3
	dbf	d6,.doNextComparison

	; Not a single match.

	; Add this chunk to the output.
	moveq	#bytesToLcnt(8*8*2),d0
-	move.l	(a1)+,(a3)+
	dbf	d0,-

	addq.l	#1,d7	; One more chunk has been added.
	dbf	d5,.nextChunk
/
	bra.s	-	; infinite loop

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E59C:
ConvertHalfOf256x256ChunkToTwo128x128Chunks:
	moveq	#8-1,d0	 ; 8 rows.
-
	; Do a row of chunk 1 (a chunk is 8 blocks wide and tall).
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	; Do a row of chunk 2.
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	dbf	d0,-

	adda.w	#8*8*2,a1
	adda.w	#8*8*2,a2

	rts
; End of function ConvertHalfOf256x256ChunkToTwo128x128Chunks

; ===========================================================================

    if gameRevision=0
	nop
    endif

    if ~~removeJmpTos
; JmpTo_PalLoad2
JmpTo_PalLoad_Now ; JmpTo
	jmp	(PalLoad_Now).l
JmpTo_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo_KosDec ; JmpTo
	jmp	(KosDec).l

	align 4
    endif
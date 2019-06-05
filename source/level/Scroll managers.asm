; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Software scroll managers

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
	zoneOffsetTableEntry.w InitCam_EHZ
	zoneOffsetTableEntry.w InitCam_Null0	; 1
	zoneOffsetTableEntry.w InitCam_WZ	; 2
	zoneOffsetTableEntry.w InitCam_Null0	; 3
	zoneOffsetTableEntry.w InitCam_Std	; 4 MTZ
	zoneOffsetTableEntry.w InitCam_Std	; 5 MTZ3
	zoneOffsetTableEntry.w InitCam_Null1	; 6
	zoneOffsetTableEntry.w InitCam_HTZ	; 7
	zoneOffsetTableEntry.w InitCam_HPZ	; 8
	zoneOffsetTableEntry.w InitCam_Null2	; 9
	zoneOffsetTableEntry.w InitCam_OOZ	; 10
	zoneOffsetTableEntry.w InitCam_MCZ	; 11
	zoneOffsetTableEntry.w InitCam_CNZ	; 12
	zoneOffsetTableEntry.w InitCam_CPZ	; 13
	zoneOffsetTableEntry.w InitCam_Null3	; 14
	zoneOffsetTableEntry.w InitCam_ARZ	; 15
	zoneOffsetTableEntry.w InitCam_SCZ	; 16
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
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.w	+
	tst.w	(Debug_placement_mode).w
	beq.w	loc_C4D0	; skip normal scrolling for SCZ
+
	tst.b	(Scroll_lock).w
	bne.s	DeformBgLayerAfterScrollVert
	lea	(MainCharacter).w,a0 ; a0=character
	lea	(Camera_X_pos).w,a1
	lea	(Camera_Min_X_pos).w,a2
	lea	(Scroll_flags).w,a3
	lea	(Camera_X_pos_diff).w,a4
	lea	(Horiz_scroll_delay_val).w,a5
	lea	(Sonic_Pos_Record_Buf).w,a6
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	lea	(Horiz_scroll_delay_val_P2).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6
+
	bsr.w	ScrollHoriz
	lea	(Horiz_block_crossed_flag).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos).w,a1
	lea	(Camera_Min_X_pos).w,a2
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
	lea	(Tails_Min_X_pos).w,a2
	lea	(Scroll_flags_P2).w,a3
	lea	(Camera_X_pos_diff_P2).w,a4
	lea	(Horiz_scroll_delay_val_P2).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6
	bsr.w	ScrollHoriz
	lea	(Horiz_block_crossed_flag_P2).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos_P2).w,a1
	lea	(Tails_Min_X_pos).w,a2
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
	zoneOffsetTableEntry.w SwScrl_EHZ	; $00
	zoneOffsetTableEntry.w SwScrl_Minimal	; $01
	zoneOffsetTableEntry.w SwScrl_Lev2	; $02
	zoneOffsetTableEntry.w SwScrl_Minimal	; $03
	zoneOffsetTableEntry.w SwScrl_MTZ	; $04
	zoneOffsetTableEntry.w SwScrl_MTZ	; $05
	zoneOffsetTableEntry.w SwScrl_WFZ	; $06
	zoneOffsetTableEntry.w SwScrl_HTZ	; $07
	zoneOffsetTableEntry.w SwScrl_HPZ	; $08
	zoneOffsetTableEntry.w SwScrl_Minimal	; $09
	zoneOffsetTableEntry.w SwScrl_OOZ	; $0A
	zoneOffsetTableEntry.w SwScrl_MCZ	; $0B
	zoneOffsetTableEntry.w SwScrl_CNZ	; $0C
	zoneOffsetTableEntry.w SwScrl_CPZ	; $0D
	zoneOffsetTableEntry.w SwScrl_DEZ	; $0E
	zoneOffsetTableEntry.w SwScrl_ARZ	; $0F
	zoneOffsetTableEntry.w SwScrl_SCZ	; $10
    zoneTableEnd
; ===========================================================================
; loc_C51E:
SwScrl_Title:
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	addq.w	#1,(Camera_X_pos).w
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#2,d2
	lea	(Horiz_Scroll_Buf).w,a1
	moveq	#0,d0

	move.w	#bytesToLcnt($280),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0

	move.w	#bytesToLcnt($80),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	move.w	#bytesToLcnt($40),d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_C57E:
SwScrl_EHZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_EHZ_2P
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	#0,d0

	move.w	#bytesToLcnt($58),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#6,d0

	move.w	#bytesToLcnt($E8),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	(SwScrl_RippleData).l,a2
	lea	(a2,d1.w),a2

	move.w	#bytesToLcnt($54),d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	move.w	#0,d0

	move.w	#bytesToLcnt($2C),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0

	move.w	#bytesToLcnt($40),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0
	move.w	d0,d1
	asr.w	#1,d1
	add.w	d1,d0

	move.w	#bytesToLcnt($40),d1
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

	move.w	#bytesToLcnt($3C),d1 ; $3C bytes
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	move.w	#($48)/8-1,d1 ; $48 bytes
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	move.w	#($B4)/12-1,d1 ; $B4 bytes
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

	; note there is a bug here. the bottom 8 pixels haven't had their hscroll values set. only the EHZ scrolling code has this bug.

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
; ===========================================================================
; loc_C6C4:
SwScrl_EHZ_2P:
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	move.w	#bytesToLcnt($2C),d1
	bsr.s	sub_C71A
	moveq	#0,d0
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	(Camera_X_pos_P2).w,d0
	move.w	#bytesToLcnt($3C),d1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_C71A:
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	#0,d0

-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#6,d0

	move.w	#bytesToLcnt($74),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea_	SwScrl_RippleData,a2
	lea	(a2,d1.w),a2

	move.w	#bytesToLcnt($2C),d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	move.w	#0,d0

	move.w	#bytesToLcnt($14),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0

	move.w	#bytesToLcnt($20),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0
	move.w	d0,d1
	asr.w	#1,d1
	add.w	d1,d0

	move.w	#bytesToLcnt($20),d1
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

	move.w	#bytesToLcnt($A0),d1
-	move.w	d2,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	rts
; End of function sub_C71A

; ===========================================================================
; unused...
; loc_C7BA:
SwScrl_Lev2:
    if gameRevision<2
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
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
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
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
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
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
	move.b	(a3)+,d0				; Number of lines in this segment
	addq.w	#1,a3					; Skip index
	sub.w	d0,d1					; Does this segment have any visible lines?
	bcc.s	.seg_loop				; Branch if not

	neg.w	d1						; d1 = number of lines to draw in this segment
	move.w	#bytesToLcnt($380),d2	; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.b	-1(a3),d3				; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0			; Fetch scroll value for this row...
	neg.w	d0						; ... and flip sign for VDP

.row_loop:
	move.l	d0,(a1)+
	subq.w	#1,d1					; Has the current segment finished?
	bne.s	.next_row				; Branch if not
	move.b	(a3)+,d1				; Fetch a new line count
	move.b	(a3)+,d3				; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0			; Fetch scroll value for this row...
	neg.w	d0						; ... and flip sign for VDP

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
	dc.b $C0,  0,$C0,  0,$80,  0,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C
	dc.b $30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8; 16
	dc.b $30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10; 32
	dc.b $80,  4,$80,  4,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10; 48
	dc.b $20,  8,$30, $C,$30,$10,$C0,  0,$C0,  0,$80,  0; 64
;byte_C916
SwScrl_WFZ_Normal_Array:
	dc.b $C0,  0,$C0,  0,$80,  0,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C
	dc.b $30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8; 16
	dc.b $30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10; 32
	dc.b $20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C; 48
	dc.b $30,$10,$20,  8,$30, $C,$30,$10,$C0,  0,$C0,  0,$80,  0; 64
; Note: this array is missing $80 lines compared to the transition array.
; This causes the lower clouds to read data from the start of SwScrl_HTZ.
; These are the missing entries:
    if 1==0
	dc.b $20,  8,$30, $C,$30,$10
    endif
; ===========================================================================
; loc_C964:
SwScrl_HTZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_HTZ_2P	; never used in normal gameplay
	tst.b	(Screen_Shaking_Flag_HTZ).w
	bne.w	HTZ_Screen_Shake
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	d2,d0
	asr.w	#3,d0

	move.w	#bytesToLcnt($200),d1
-	move.l	d0,(a1)+
	dbf	d1,-

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
	lea	(TempArray_LayerDef).w,a2
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

	moveq	#3,d1
-	move.w	d3,(a2)+
	move.w	d3,(a2)+
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

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
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#6,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#7,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#9,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#$E,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3

	move.w	#2,d2
-	move.w	d3,d4

	move.w	#$F,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d2,--

	rts
; ===========================================================================

;loc_CA92:
HTZ_Screen_Shake:
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	lsl.l	#8,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#0,d6
	bsr.w	SetVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.w	(Camera_Y_pos).w,(Vscroll_Factor_FG).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	moveq	#0,d2
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
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
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
; loc_CB10:
SwScrl_HTZ_2P:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#6,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#2,d5
	moveq	#0,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.b	#0,(Scroll_flags_BG).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($1C0),d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	(Camera_X_pos_diff_P2).w,d4
	ext.l	d4
	asl.l	#6,d4
	add.l	d4,(Camera_BG_X_pos_P2).w
	moveq	#0,d0
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	#bytesToLcnt($1D0),d1
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
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#6,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#7,d5
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	move.w	d2,d0
	asr.w	#1,d0

	move.w	#7,d1
-	move.w	d0,(a1)+
	dbf	d1,-

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
	lea	(TempArray_LayerDef+$60).w,a2
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
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

	move.w	#$19,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	adda.w	#$E,a1
	move.w	d2,d0
	asr.w	#1,d0

	move.w	#$17,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	lea	(TempArray_LayerDef).w,a2
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,d2
	andi.w	#$3F0,d0
	lsr.w	#3,d0
	lea	(a2,d0.w),a2
	bra.w	SwScrl_HPZ_Continued
; ===========================================================================
; loc_CC66:
SwScrl_OOZ:
	move.w	(Camera_X_pos_diff).w,d0
	ext.l	d0
	asl.l	#5,d0
	add.l	d0,(Camera_BG_X_pos).w
	move.w	(Camera_Y_pos_diff).w,d0
	ext.l	d0
	asl.l	#5,d0
	move.l	(Camera_BG_Y_pos).w,d3
	add.l	d3,d0
	moveq	#4,d6
	bsr.w	SetVertiScrollFlagsBG2
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf+$380).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d7
	neg.w	d7
	move.w	(Camera_BG_Y_pos).w,d1
	subi.w	#$50,d1
	bcc.s	+
	moveq	#0,d1
+
	subi.w	#$B0,d1
	bcs.s	+
	moveq	#0,d1
+
	move.w	#$DF,d6
	add.w	d6,d1
	move.w	d7,d0
	bsr.s	OOZ_BGScroll_Lines
	bsr.s	OOZ_BGScroll_MediumClouds
	bsr.s	OOZ_BGScroll_SlowClouds
	bsr.s	OOZ_BGScroll_FastClouds
	move.w	d7,d0
	asr.w	#4,d0
	moveq	#6,d1
	bsr.s	OOZ_BGScroll_Lines
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	moveq	#$20,d1
-	move.b	(a2)+,d0
	ext.w	d0
	move.l	d0,-(a1)
	subq.w	#1,d6
	bmi.s	+	; rts
	dbf	d1,-

	bsr.s	OOZ_BGScroll_MediumClouds
	bsr.s	OOZ_BGScroll_SlowClouds
	bsr.s	OOZ_BGScroll_FastClouds
	bsr.s	OOZ_BGScroll_SlowClouds
	bsr.s	OOZ_BGScroll_MediumClouds
	move.w	d7,d0
	moveq	#$47,d1
	bsr.s	OOZ_BGScroll_Lines
+	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_CD0A
OOZ_BGScroll_FastClouds:
	move.w	d7,d0
	asr.w	#2,d0
	bra.s	+
; End of function OOZ_BGScroll_FastClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_CD10
OOZ_BGScroll_MediumClouds:
	move.w	d7,d0
	asr.w	#3,d0
	bra.s	+
; End of function OOZ_BGScroll_MediumClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_CD16
OOZ_BGScroll_SlowClouds:
	move.w	d7,d0
	asr.w	#4,d0

+
	moveq	#7,d1
; End of function OOZ_BGScroll_SlowClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Scrolls min(d6,d1+1) lines by an (constant) amount specified in d0

;sub_CD1C
OOZ_BGScroll_Lines:
	move.l	d0,-(a1)
	subq.w	#1,d6
	bmi.s	+
	dbf	d1,OOZ_BGScroll_Lines

	rts
; ===========================================================================
+
	addq.l	#4,sp
	rts
; End of function OOZ_BGScroll_Lines

; ===========================================================================
; loc_CD2C:
SwScrl_MCZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_MCZ_2P
	move.w	(Camera_Y_pos).w,d0
	move.l	(Camera_BG_Y_pos).w,d3
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	bra.s	++
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
+
	swap	d0
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG2
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	moveq	#0,d2
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
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	lea	(TempArray_LayerDef).w,a2
	lea	$1E(a2),a3
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$E(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,8(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6(a2)
	move.w	d1,$10(a2)
	move.w	d1,$1C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4(a2)
	move.w	d1,$12(a2)
	move.w	d1,$1A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2(a2)
	move.w	d1,$14(a2)
	move.w	d1,$18(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,(a2)
	move.w	d1,$16(a2)
	lea	(SwScrl_MCZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($380),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	rts
; ===========================================================================
; byte_CE6C:
SwScrl_MCZ_RowHeights:
	dc.b $25
	dc.b $17	; 1
	dc.b $12	; 2
	dc.b   7	; 3
	dc.b   7	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b $30	; 7
	dc.b  $D	; 8
	dc.b $13	; 9
	dc.b $20	; 10
	dc.b $40	; 11
	dc.b $20	; 12
	dc.b $13	; 13
	dc.b  $D	; 14
	dc.b $30	; 15
	dc.b   2	; 16
	dc.b   2	; 17
	dc.b   7	; 18
	dc.b   7	; 19
	dc.b $20	; 20
	dc.b $12	; 21
	dc.b $17	; 22
	dc.b $25	; 23
	even
; ===========================================================================
; loc_CE84:
SwScrl_MCZ_2P:
	moveq	#0,d0
	move.w	(Camera_Y_pos).w,d0
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	bra.s	++
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
+
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	lea	(TempArray_LayerDef).w,a2
	lea	$1E(a2),a3
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$E(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,8(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6(a2)
	move.w	d1,$10(a2)
	move.w	d1,$1C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4(a2)
	move.w	d1,$12(a2)
	move.w	d1,$1A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2(a2)
	move.w	d1,$14(a2)
	move.w	d1,$18(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,(a2)
	move.w	d1,$16(a2)
	lea	(SwScrl_MCZ2P_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	lsr.w	#1,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($1C0),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	bra.s	+
; ===========================================================================
; byte_CF90:
SwScrl_MCZ2P_RowHeights:
	dc.b $13
	dc.b  $B
	dc.b   9	; 1
	dc.b   4	; 2
	dc.b   3	; 3
	dc.b   1	; 4
	dc.b   1	; 5
	dc.b $18	; 6
	dc.b   6	; 7
	dc.b  $A	; 8
	dc.b $10	; 9
	dc.b $20	; 10
	dc.b $10	; 11
	dc.b  $A	; 12
	dc.b   6	; 13
	dc.b $18	; 14
	dc.b   1	; 15
	dc.b   1	; 16
	dc.b   3	; 17
	dc.b   4	; 18
	dc.b $10	; 19
	dc.b   9	; 20
	dc.b  $B	; 21
	dc.b $13	; 22
	even
; ===========================================================================
+
	moveq	#0,d0
	move.w	(Camera_Y_pos_P2).w,d0
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	bra.s	++
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
+
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	lea	(TempArray_LayerDef).w,a2
	lea	$1E(a2),a3
	move.w	(Camera_X_pos_P2).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$E(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,8(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6(a2)
	move.w	d1,$10(a2)
	move.w	d1,$1C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4(a2)
	move.w	d1,$12(a2)
	move.w	d1,$1A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2(a2)
	move.w	d1,$14(a2)
	move.w	d1,$18(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,(a2)
	move.w	d1,$16(a2)
	lea_	SwScrl_MCZ2P_RowHeights+1,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	(Camera_BG_Y_pos_P2).w,d1
	lsr.w	#1,d1
	moveq	#$17,d0
	bra.s	+
; ===========================================================================
-
	move.b	(a3)+,d0
+
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($1D0),d2
	move.w	(Camera_X_pos_P2).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	rts
; ===========================================================================
; loc_D0C6:
SwScrl_CNZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_CNZ_2P
	move.w	(Camera_Y_pos).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.w	(Camera_X_pos).w,d2
	bsr.w	sub_D160
	lea	(SwScrl_CNZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($380),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+

-	move.w	(a2)+,d0
	neg.w	d0
	move.b	(a3)+,d1
	beq.s	++
+	dbf	d2,--

	rts
; ===========================================================================
+
	move.w	#bytesToLcnt($40),d1
	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d0
	lsr.w	#3,d0
	neg.w	d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a4
	lea	(a4,d0.w),a4

-	move.b	(a4)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	subi.w	#$10,d2
	bra.s	--
; ===========================================================================
; byte_D156:
SwScrl_CNZ_RowHeights:
	dc.b  $10
	dc.b  $10	; 1
	dc.b  $10	; 2
	dc.b  $10	; 3
	dc.b  $10	; 4
	dc.b  $10	; 5
	dc.b  $10	; 6
	dc.b  $10	; 7
	dc.b    0	; 8
	dc.b -$10	; 9
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_D160:
	lea	(TempArray_LayerDef).w,a1
	move.w	d2,d0
	asr.w	#3,d0
	sub.w	d2,d0
	ext.l	d0
	asl.l	#5,d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3

	move.w	#6,d1
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
	move.w	(Camera_Y_pos).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	move.w	(Camera_X_pos).w,d2
	bsr.w	sub_D160
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d0
	move.w	#$6F,d2
	lea	(SwScrl_CNZ2P_RowHeights+2).l,a3
	bsr.s	sub_D216
	move.w	(Camera_Y_pos_P2).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	move.w	(Camera_X_pos_P2).w,d2
	bsr.w	sub_D160
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	(Camera_BG_Y_pos_P2).w,d1
	moveq	#0,d0
	move.w	(Camera_X_pos_P2).w,d0
	move.w	#bytesToLcnt($1D0),d2
	lea	(SwScrl_CNZ2P_RowHeights+1).l,a3

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_D216:
	lsr.w	#1,d1
	lea	(TempArray_LayerDef).w,a2
	moveq	#0,d3

-	move.b	(a3)+,d3
	addq.w	#2,a2
	sub.w	d3,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+

-	move.w	(a2)+,d0
	neg.w	d0
	move.b	(a3)+,d1
	beq.s	++
+
	dbf	d2,--

	rts
; ===========================================================================
+
	move.w	#bytesToLcnt($20),d1
	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d0
	lsr.w	#3,d0
	neg.w	d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a4
	lea	(a4,d0.w),a4

-	move.b	(a4)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	subq.w	#8,d2
	bra.s	--
; End of function sub_D216

; ===========================================================================
; byte_D270:
SwScrl_CNZ2P_RowHeights:
	dc.b   4
	dc.b   4	; 1
	dc.b   8	; 2
	dc.b   8	; 3
	dc.b   8	; 4
	dc.b   8	; 5
	dc.b   8	; 6
	dc.b   8	; 7
	dc.b   8	; 8
	dc.b   8	; 9
	dc.b   0	; 10
	dc.b $78	; 11
	even
; ===========================================================================
; loc_D27C:
SwScrl_CPZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#7,d4
	moveq	#4,d6
	bsr.w	SetHorizScrollFlagsBG2
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,(Camera_BG2_Y_pos).w
	move.w	d0,(Vscroll_Factor_BG).w
	move.b	(Scroll_flags_BG).w,d0
	or.b	(Scroll_flags_BG2).w,d0
	move.b	d0,(Scroll_flags_BG3).w
	clr.b	(Scroll_flags_BG).w
	clr.b	(Scroll_flags_BG2).w
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
	lea	(a0,d0.w),a0
	move.w	d0,d4
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#$E,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	andi.w	#$F,d2
	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#$12,d4
	beq.s	loc_D34A
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0
	add.w	d2,d2
	jmp	++(pc,d2.w)
; ===========================================================================

-	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#$12,d4
	beq.s	+++
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0

+   rept 16
	move.l	d0,(a1)+
    endm
	addq.b	#1,d4
	dbf	d1,-
	rts
; ===========================================================================

loc_D34A:
	move.w	#bytesToLcnt($40),d0
	sub.w	d2,d0
	move.w	d0,d2
	bra.s	++
; ===========================================================================
+
	move.w	#$F,d2
+
	move.w	(Camera_BG_X_pos).w,d3
	neg.w	d3
	move.w	(TempArray_LayerDef).w,d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a2
	lea	(a2,d0.w),a2

-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d2,-

	addq.b	#1,d4
	dbf	d1,--
	rts
; ===========================================================================
; loc_D382:
SwScrl_DEZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#8,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.w	(Camera_X_pos).w,d4
	lea	(TempArray_LayerDef).w,a2
	move.w	d4,(a2)+

	addq.w	#3,(a2)+ ; these random-seeming numbers control how fast each row of stars scrolls by
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

	move.w	(a2)+,d0 ; this is to make one row go at half speed (1 pixel every other frame)
	moveq	#0,d1
	move.w	d0,d1
	lsr.w	#1,d0
	move.w	d0,(a2)+

	addq.w	#3,(a2)+ ; more star speeds...
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+

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
	addq.w	#4,a2
	addq.w	#1,(a2)+
	move.w	d4,(a2)+
	move.w	d4,(a2)+
	move.w	d4,(a2)+
	lea	(SwScrl_DEZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($380),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

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
	rts
; ===========================================================================
; byte_D48A:
SwScrl_DEZ_RowHeights:
	dc.b $80
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
	dc.b   3	; 29
	dc.b   5	; 30
	dc.b   8	; 31
	dc.b $10	; 32
	dc.b $80	; 33
	dc.b $80	; 34
	dc.b $80	; 35
	even
; ===========================================================================
; loc_D4AE:
SwScrl_ARZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	muls.w	#$119,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG_ARZ
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#7,d5
	tst.b	(Current_Act).w
	bne.s	+
	asl.l	#1,d5
+
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG

	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	.screenNotShaking

	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	; Shake camera Y-pos (note that BG scrolling is not affected by this, causing it to distort)
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	; Shake camera X-pos
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w

.screenNotShaking:
	lea	(TempArray_LayerDef).w,a2	; Starts at BG scroll row 1
	lea	6(a2),a3			; Starts at BG scroll row 4

	; Set up the speed of each row (there are 16 rows in total)
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1

	; Set row 4's speed
	swap	d1
	move.w	d1,(a3)+	; Top row of background moves 10 ($A) times slower than foreground
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
	; This code seems to pre-date the Simon Wai build, which uses the final's
	; scrolling.
	move.w	d1,(a2)		; Set row 1's speed
	move.w	d1,4(a2)	; Set row 3's speed

	move.w	(Camera_BG_X_pos).w,d0
	move.w	d0,2(a2)	; Set row 2's speed
	move.w	d0,$16(a2)	; Set row 12's speed
	_move.w	d0,0(a2)	; Overwrite row 1's speed (now same as row 2's)
	move.w	d0,4(a2)	; Overwrite row 3's speed (now same as row 2's)
	move.w	d0,$18(a2)	; Set row 13's speed
	move.w	d0,$1A(a2)	; Set row 14's speed
	move.w	d0,$1C(a2)	; Set row 15's speed
	move.w	d0,$1E(a2)	; Set row 16's speed

	lea	(SwScrl_ARZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

	; Find which row of background is visible at the top of the screen
.findTopRowLoop:
	move.b	(a3)+,d0	; Get row height
	addq.w	#2,a2		; Next row speed (note: is off by 2. This is fixed below)
	sub.w	d0,d1
	bcc.s	.findTopRowLoop		; If current row is above the screen, loop and do next row

	neg.w	d1	; d1 now contains how many pixels of the row is currently on-screen
	subq.w	#2,a2	; Get correct row speed

	move.w	#bytesToLcnt($380),d2	; Actual size of Horiz_Scroll_Buf
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
	dc.b $B0
	dc.b $70	; 1
	dc.b $30	; 2
	dc.b $60	; 3
	dc.b $15	; 4
	dc.b  $C	; 5
	dc.b  $E	; 6
	dc.b   6	; 7
	dc.b  $C	; 8
	dc.b $1F	; 9
	dc.b $30	; 10
	dc.b $C0	; 11
	dc.b $F0	; 12
	dc.b $F0	; 13
	dc.b $F0	; 14
	dc.b $F0	; 15
	even
; ===========================================================================
; loc_D5DE:
SwScrl_SCZ:
	tst.w	(Debug_placement_mode).w
	bne.w	SwScrl_Minimal
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
	move.w	(Camera_X_pos_diff).w,d4
	beq.s	+
	move.w	#$100,d4
+
	ext.l	d4
	asl.l	#7,d4
	moveq	#0,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
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
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
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
	move.w	#$E,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	andi.w	#$F,d2
	add.w	d2,d2
	move.w	(a2)+,d0
	jmp	+(pc,d2.w)
; ===========================================================================

-	move.w	(a2)+,d0

+   rept 16
	move.l	d0,(a1)+
    endm
	dbf	d1,-

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
	bset	#2,(a3)		; set moving back in level bit
	rts
; ===========================================================================
+
	bset	#3,(a3)		; set moving forward in level bit
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
	move.w	(a5),d1		; should scrolling be delayed?
	beq.s	.scrollNotDelayed	; if not, branch
	subi.w	#$100,d1	; reduce delay value
	move.w	d1,(a5)
	moveq	#0,d1
	move.b	(a5),d1		; get delay value
	lsl.b	#2,d1		; multiply by 4, the size of a position buffer entry
	addq.b	#4,d1
	move.w	2(a5),d0	; get current position buffer index
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
	add.w	(a1),d0		; get new camera position
	cmp.w	(a2),d0		; is it greater than the minimum position?
	bgt.s	.doScroll		; if it is, branch
	move.w	(a2),d0		; prevent camera from going any further back
	bra.s	.doScroll
; ===========================================================================
; loc_D758:
.scrollRight:
	cmpi.w	#16,d0
	blo.s	.maxNotReached2
	move.w	#16,d0
; loc_D762:
.maxNotReached2:
	add.w	(a1),d0		; get new camera position
	cmp.w	Camera_Max_X_pos-Camera_Min_X_pos(a2),d0	; is it less than the max position?
	blt.s	.doScroll	; if it is, branch
	move.w	Camera_Max_X_pos-Camera_Min_X_pos(a2),d0	; prevent camera from going any further forward
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
	clr.w	(a4)		; clear Y position difference (Camera_Y_pos_bias)
	rts
; ===========================================================================
; loc_D7C4:
.decideScrollType:
	cmpi.w	#(224/2)-16,d3		; is the camera bias normal?
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
	cmp.w	Camera_Min_Y_pos-Camera_Min_X_pos(a2),d1	; is the new position less than the minimum Y pos?
	bgt.s	.doScroll	; if not, branch
	cmpi.w	#-$100,d1
	bgt.s	.minYPosReached
	andi.w	#$7FF,d1
	andi.w	#$7FF,(a1)
	bra.s	.doScroll
; ===========================================================================
; loc_D844:
.minYPosReached:
	move.w	Camera_Min_Y_pos-Camera_Min_X_pos(a2),d1	; prevent camera from going any further up
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
	cmp.w	Camera_Max_Y_pos_now-Camera_Min_X_pos(a2),d1	; is the new position greater than the maximum Y pos?
	blt.s	.doScroll	; if not, branch
	subi.w	#$800,d1
	bcs.s	.maxYPosReached
	subi.w	#$800,(a1)
	bra.s	.doScroll
; ===========================================================================
; loc_D864:
.maxYPosReached:
	move.w	Camera_Max_Y_pos_now-Camera_Min_X_pos(a2),d1	; prevent camera from going any further down
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
	bset	#0,(a3)		; set moving up in level bit
	rts
; ===========================================================================
+
	bset	#1,(a3)		; set moving down in level bit
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
	bset	#2,(Scroll_flags_BG).w
	bra.s	++
; ===========================================================================
+
	bset	#3,(Scroll_flags_BG).w
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
	bset	#0,(Scroll_flags_BG).w
	rts
; ===========================================================================
+
	bset	#1,(Scroll_flags_BG).w
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
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Verti_block_crossed_flag_BG).w,d2
	eor.b	d2,d1
	bne.s	++	; rts
	eori.b	#$10,(Verti_block_crossed_flag_BG).w
	sub.l	d3,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG).w	; everytime Verti_block_crossed_flag_BG changes from $10 to $00
	rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w	; everytime Verti_block_crossed_flag_BG changes from $00 to $10
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
	bcs.s	+
	bhi.s	++
	rts
; ===========================================================================
+
	cmpi.w	#-$10,d0
	bgt.s	++
	move.w	#-$10,d0
	bra.s	++
; ===========================================================================
+
	cmpi.w	#$10,d0
	blo.s	+
	move.w	#$10,d0
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

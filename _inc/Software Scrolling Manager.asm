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
	subi.w	#screen_height,(Vscroll_Factor_P2_BG).w

	; Update the foregrounds's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#screen_height,(Vscroll_Factor_P2_FG).w

	; Only allow the screen to vertically scroll two pixels at a time.
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w

	; Update the background's (and foreground's) horizontal scrolling.
	; This creates an elaborate parallax effect.
	; Tails' screen is slightly taller, to fill the gap between the two
	; screens.
	lea	(Horiz_Scroll_Buf+(screen_height/2-4)*2*2).w,a1
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
	move.w	#screen_height-1,d1
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
	move.w	#screen_height-1,d1
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
    if fixBugs
	moveq	#0,d5
	move.w	(Camera_X_pos_diff).w,d5	; get camera x-diff
	ext.l	d5
	asl.l	#5,d5
	add.l	d5,(a2)				; add to high word of accumulation
	addi.l	#$8000,(a2)+			; larger clouds
	add.l	d5,(a2)
	addi.l	#$4000,(a2)+			; medium clouds
	add.l	d5,(a2)
	addi.l	#$2000,(a2)+			; small clouds
    else
	; This tallies only the cloud speeds. It works fine if you are standing
	; still, but makes the clouds move faster when going right and slower when
	; going left. This is exactly the opposite of what should happen.
	addi.l	#$8000,(a2)+			; larger clouds
	addi.l	#$4000,(a2)+			; medium clouds
	addi.l	#$2000,(a2)+			; small clouds
    endif
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
	move.w	#screen_height-1,d2		; Number of rows in hscroll buffer
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
	; Use different background scrolling code for two player mode...
	; despite the fact that Hill Top Zone is not normally playable in
	; two-player mode.
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_HTZ_2P

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

	; The remaining lines of code in this function compose the animating clouds.
	move.l	d0,d4
	move.w	(TempArray_LayerDef+$22).w,d0
	addq.w	#4,(TempArray_LayerDef+$22).w

	; Get delta between camera X and the cloud scroll value.
	sub.w	d0,d2

	; This big block of code divides and then multiplies the delta by roughly 2.28,
	; effectively subtracting 'delta modulo 2.28' from the delta.
	; I have no idea why this is necessary.

	; Start by reducing to 44% (100% divided by 2.28)...
	move.w	d2,d0
    if fixBugs
	; See below.
	moveq	#0,d1
    endif
	move.w	d0,d1
	asr.w	#1,d0 ; Divide d0 by 2
    if fixBugs
	; See below.
	swap	d1
	asr.l	#4,d1 ; Divide d1 by 16, preserving the remainder in the lower 16 bits
	swap	d1
    else
	asr.w	#4,d1 ; Divide d1 by 16, discarding the remainder
    endif
	sub.w	d1,d0 ; 100 / 2 - 100 / 16 = 44
	ext.l	d0
	; ...then increase the result to 228%, effectively undoing the reduction to 44% from earlier (0.44 x 2.28 = 1).
	asl.l	#8,d0 ; Multiply by 256
	divs.w	#256*44/100,d0 ; Divide by 112, which is 44% of 256
	ext.l	d0

	; We are done subtracting 'delta modulo 2.28' from the delta.

	; Multiply the delta by 256.
	asl.l	#8,d0

	lea	(TempArray_LayerDef).w,a2	; See 'Dynamic_HTZ.doCloudArt'.

    if fixBugs
	move.l	d1,d3 ; d1 holds the original, pre-modulo delta divided by 16.
    else
	; d3 is used as a fixed-point accumulator here, with the upper 16 bits
	; holding the integer part, and the lower 16 bits holding the decimal
	; part. This accumulator is initialised to the value of the delta
	; divided by 16, however, the decimal part of this division was not
	; preserved. This loss of precision causes the clouds to scroll with a
	; visible jerkiness.
	moveq	#0,d3
	move.w	d1,d3 ; d1 holds the original, pre-modulo delta divided by 16.
    endif

    rept 3
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
    endm
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
	move.w	(Level_frame_counter).w,d0
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
	move.w	#screen_height-1,d1
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
	subi.w	#screen_height,(Vscroll_Factor_P2_BG).w

	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#screen_height,(Vscroll_Factor_P2_FG).w

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
	lea	(Horiz_Scroll_Buf+screen_height*2*2).w,a1

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
	move.w	#screen_height-1,d6

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

	move.w	(Level_frame_counter).w,d0
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
	move.w	#screen_height-1,d2		; Number of rows in hscroll buffer
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
	subi.w	#screen_height,(Vscroll_Factor_P2_BG).w

	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#screen_height,(Vscroll_Factor_P2_FG).w

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
	move.w	#screen_height-1,d2		; Number of rows in hscroll buffer
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
	subi.w	#screen_height,(Vscroll_Factor_P2_BG).w

	; Update the foreground's vertical scrolling.
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#screen_height,(Vscroll_Factor_P2_FG).w

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
	move.w	#screen_height/block_height-1,d1
    else
	; The '+1' is so that, if one block is partially-offscreen at the
	; top, then another will fill the gap at the bottom of the screen.
	; This causes 'Horiz_Scroll_Buf' to overflow due to a lack of
	; bounds-checking. This was likely a deliberate optimisation. Still,
	; it's possible to avoid this without any performance penalty with a
	; little extra code. See below.
	move.w	#screen_height/block_height+1-1,d1
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
	move.w	(Level_frame_counter).w,d0
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
	move.w	#screen_height-1,d2		; Number of rows in hscroll buffer
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
	move.w	(Level_frame_counter).w,d0
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

	move.w	(Level_frame_counter).w,d0
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

	move.w	#screen_height-1,d2 	; Height of screen
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
	move.w	#screen_height-1,d1
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
	move.w	#screen_height-1,d1
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
	move.w	#screen_height/block_height-1,d1
    else
	; The '+1' is so that, if one block is partially-offscreen at the
	; top, then another will fill the gap at the bottom of the screen.
	; This causes 'Horiz_Scroll_Buf' to overflow due to a lack of
	; bounds-checking. This was likely a deliberate optimisation. Still,
	; it's possible to avoid this without any performance penalty with a
	; little extra code. See below.
	move.w	#screen_height/block_height+1-1,d1
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

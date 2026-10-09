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

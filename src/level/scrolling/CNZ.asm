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

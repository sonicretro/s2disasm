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

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

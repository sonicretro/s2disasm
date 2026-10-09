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

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

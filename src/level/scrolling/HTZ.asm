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

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

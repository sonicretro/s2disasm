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

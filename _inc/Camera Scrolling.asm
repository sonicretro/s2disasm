; ---------------------------------------------------------------------------
; Subroutine to set horizontal scroll flags
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D6E2:
SetHorizScrollFlags:
	move.w	(a1),d0		; get camera X pos
	andi.w	#$10,d0
	move.b	(a2),d1
	eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
	bne.s	++		; if not, branch
	eori.b	#$10,(a2)
	move.w	(a1),d0		; get camera X pos
	sub.w	d4,d0		; subtract previous camera X pos
	bpl.s	+		; branch if the camera has moved forward
	bset	#scroll_flag_fg_left,(a3)	; set moving back in level bit
	rts
; ===========================================================================
+
	bset	#scroll_flag_fg_right,(a3)	; set moving forward in level bit
+
	rts
; End of function SetHorizScrollFlags

; ---------------------------------------------------------------------------
; Subroutine to scroll the camera horizontally
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D704:
ScrollHoriz:
	move.w	(a1),d4		; get camera X pos
	tst.b	(Teleport_flag).w
	bne.s	.return		; if a teleport is in progress, return
    if fixBugs
	; To prevent the bug that is described below, this caps the position
	; array index offset so that it does not access position data from
	; before the spin dash was performed. Note that this required
	; modifications to 'Sonic_UpdateSpindash' and 'Tails_UpdateSpindash'.
	move.b	Horiz_scroll_delay_val-Camera_Delay(a5),d1	; should scrolling be delayed?
	beq.s	.scrollNotDelayed				; if not, branch
	lsl.b	#2,d1		; multiply by 4, the size of a position buffer entry
	subq.b	#1,Horiz_scroll_delay_val-Camera_Delay(a5)	; reduce delay value
	move.b	Sonic_Pos_Record_Index+1-Camera_Delay(a5),d0
	sub.b	Horiz_scroll_delay_val+1-Camera_Delay(a5),d0
	cmp.b	d0,d1
	blo.s	.doNotCap
	move.b	d0,d1
.doNotCap:
    else
	; The intent of this code is to make the camera briefly lag behind the
	; player right after releasing a spin dash, however it does this by
	; simply making the camera use position data from previous frames. This
	; means that if the camera had been moving recently enough, then
	; releasing a spin dash will cause the camera to jerk around instead of
	; remain still. This can be encountered by running into a wall, and
	; quickly turning around and spin dashing away. Sonic 3 would have had
	; this same issue with the Fire Shield's dash abiliity, but it shoddily
	; works around the issue by resetting the old position values to the
	; current position (see 'Reset_Player_Position_Array').
	move.w	Horiz_scroll_delay_val-Camera_Delay(a5),d1	; should scrolling be delayed?
	beq.s	.scrollNotDelayed				; if not, branch
	subi.w	#$100,d1					; reduce delay value
	move.w	d1,Horiz_scroll_delay_val-Camera_Delay(a5)
	moveq	#0,d1
	move.b	Horiz_scroll_delay_val-Camera_Delay(a5),d1	; get delay value
	lsl.b	#2,d1		; multiply by 4, the size of a position buffer entry
	addq.b	#4,d1
    endif
	move.w	Sonic_Pos_Record_Index-Camera_Delay(a5),d0	; get current position buffer index
	sub.b	d1,d0
	move.w	(a6,d0.w),d0	; get Sonic's position a certain number of frames ago
	andi.w	#$3FFF,d0
	bra.s	.checkIfShouldScroll	; use that value for scrolling
; ===========================================================================
; loc_D72E:
.scrollNotDelayed:
	move.w	x_pos(a0),d0
; loc_D732:
.checkIfShouldScroll:
	sub.w	(a1),d0
	subi.w	#(screen_width/2)-16,d0		; is the player less than 144 pixels from the screen edge?
	blt.s	.scrollLeft	; if he is, scroll left
	subi.w	#16,d0		; is the player more than 159 pixels from the screen edge?
	bge.s	.scrollRight	; if he is, scroll right
	clr.w	(a4)		; otherwise, don't scroll
; return_D742:
.return:
	rts
; ===========================================================================
; loc_D744:
.scrollLeft:
	cmpi.w	#-16,d0
	bgt.s	.maxNotReached
	move.w	#-16,d0		; limit scrolling to 16 pixels per frame
; loc_D74E:
.maxNotReached:
	add.w	(a1),d0						; get new camera position
	cmp.w	Camera_Min_X_pos-Camera_Boundaries(a2),d0	; is it greater than the minimum position?
	bgt.s	.doScroll					; if it is, branch
	move.w	Camera_Min_X_pos-Camera_Boundaries(a2),d0	; prevent camera from going any further back
	bra.s	.doScroll
; ===========================================================================
; loc_D758:
.scrollRight:
	cmpi.w	#16,d0
	blo.s	.maxNotReached2
	move.w	#16,d0
; loc_D762:
.maxNotReached2:
	add.w	(a1),d0						; get new camera position
	cmp.w	Camera_Max_X_pos-Camera_Boundaries(a2),d0	; is it less than the max position?
	blt.s	.doScroll					; if it is, branch
	move.w	Camera_Max_X_pos-Camera_Boundaries(a2),d0	; prevent camera from going any further forward
; loc_D76E:
.doScroll:
	move.w	d0,d1
	sub.w	(a1),d1		; subtract old camera position
	asl.w	#8,d1		; shift up by a byte
	move.w	d0,(a1)		; set new camera position
	move.w	d1,(a4)		; set difference between old and new positions
	rts
; End of function ScrollHoriz

; ---------------------------------------------------------------------------
; Subroutine to scroll the camera vertically
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; The upper 16 bits of Camera_Y_pos is the actual Y-pos, the lower ones seem
; unused, yet this code goes to a strange extent to manage them.
;sub_D77A:
ScrollVerti:
	moveq	#0,d1
	move.w	y_pos(a0),d0
	sub.w	(a1),d0		; subtract camera Y pos
	cmpi.w	#-$100,(Camera_Min_Y_pos).w ; does the level wrap vertically?
	bne.s	.noWrap		; if not, branch
	andi.w	#$7FF,d0
; loc_D78E:
.noWrap:
	btst	#status.player.rolling,status(a0)	; is the player rolling?
	beq.s	.notRolling	; if not, branch
	subq.w	#5,d0		; subtract difference between standing and rolling heights
    if fixBugs
	; Tails is shorter than Sonic, so the above subtraction actually
	; causes the camera to jolt slightly when he goes from standing to
	; rolling, and vice versa. Not even Sonic 3 & Knuckles fixed this.
	; To fix this, just adjust the subtraction to suit Tails (who is four
	; pixels shorter).
	cmpi.b	#ObjID_Tails,id(a0)
	bne.s	.notRolling
	addq.w	#4,d0
    endif
; loc_D798:
.notRolling:
	btst	#status.player.in_air,status(a0)			; is the player in the air?
	beq.s	.checkBoundaryCrossed_onGround	; if not, branch
;.checkBoundaryCrossed_inAir:
	; If Sonic's in the air, he has $20 pixels above and below him to move without disturbing the camera.
	; The camera movement is also only capped at $10 pixels.
	addi.w	#$20,d0
	sub.w	d3,d0
	bcs.s	.doScroll_fast	; If Sonic is above the boundary, scroll to catch up to him
	subi.w	#$40,d0
	bcc.s	.doScroll_fast	; If Sonic is below the boundary, scroll to catch up to him
	tst.b	(Camera_Max_Y_Pos_Changing).w	; is the max Y pos changing?
	bne.s	.scrollUpOrDown_maxYPosChanging	; if it is, branch
	bra.s	.doNotScroll
; ===========================================================================
; loc_D7B6:
.checkBoundaryCrossed_onGround:
	; On the ground, the camera follows Sonic very strictly.
	sub.w	d3,d0				; subtract camera bias
	bne.s	.decideScrollType		; If Sonic has moved, scroll to catch up to him
	tst.b	(Camera_Max_Y_Pos_Changing).w	; is the max Y pos changing?
	bne.s	.scrollUpOrDown_maxYPosChanging	; if it is, branch
; loc_D7C0:
.doNotScroll:
	clr.w	(a4)		; clear Y position difference (Camera_Y_pos_diff)
	rts
; ===========================================================================
; loc_D7C4:
.decideScrollType:
	cmpi.w	#(screen_height/2)-16,d3	; is the camera bias normal?
	bne.s	.doScroll_slow	; if not, branch
	mvabs.w	inertia(a0),d1	; get player ground velocity, force it to be positive
	cmpi.w	#$800,d1	; is the player travelling very fast?
	bhs.s	.doScroll_fast	; if he is, branch
;.doScroll_medium:
	move.w	#6<<8,d1	; If player is going too fast, cap camera movement to 6 pixels per frame
	cmpi.w	#6,d0		; is player going down too fast?
	bgt.s	.scrollDown_max	; if so, move camera at capped speed
	cmpi.w	#-6,d0		; is player going up too fast?
	blt.s	.scrollUp_max	; if so, move camera at capped speed
	bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
; loc_D7EA:
.doScroll_slow:
	move.w	#2<<8,d1	; If player is going too fast, cap camera movement to 2 pixels per frame
	cmpi.w	#2,d0		; is player going down too fast?
	bgt.s	.scrollDown_max	; if so, move camera at capped speed
	cmpi.w	#-2,d0		; is player going up too fast?
	blt.s	.scrollUp_max	; if so, move camera at capped speed
	bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
; loc_D7FC:
.doScroll_fast:
	; related code appears in ScrollBG
	; S3K uses 24 instead of 16
	move.w	#16<<8,d1	; If player is going too fast, cap camera movement to $10 pixels per frame
	cmpi.w	#16,d0		; is player going down too fast?
	bgt.s	.scrollDown_max	; if so, move camera at capped speed
	cmpi.w	#-16,d0		; is player going up too fast?
	blt.s	.scrollUp_max	; if so, move camera at capped speed
	bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
; loc_D80E:
.scrollUpOrDown_maxYPosChanging:
	moveq	#0,d0		; Distance for camera to move = 0
	move.b	d0,(Camera_Max_Y_Pos_Changing).w	; clear camera max Y pos changing flag
; loc_D814:
.scrollUpOrDown:
	moveq	#0,d1
	move.w	d0,d1		; get position difference
	add.w	(a1),d1		; add old camera Y position
	tst.w	d0		; is the camera to scroll down?
	bpl.w	.scrollDown	; if it is, branch
	bra.w	.scrollUp
; ===========================================================================
; loc_D824:
.scrollUp_max:
	neg.w	d1	; make the value negative (since we're going backwards)
	ext.l	d1
	asl.l	#8,d1	; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
	add.l	(a1),d1	; add the two, getting the new Camera_Y_pos value
	swap	d1	; actual Y-coordinate is now the low word
; loc_D82E:
.scrollUp:
	cmp.w	Camera_Min_Y_pos-Camera_Boundaries(a2),d1	; is the new position less than the minimum Y pos?
	bgt.s	.doScroll	; if not, branch
	cmpi.w	#-$100,d1
	bgt.s	.minYPosReached
	andi.w	#$7FF,d1
	andi.w	#$7FF,(a1)
	bra.s	.doScroll
; ===========================================================================
; loc_D844:
.minYPosReached:
	move.w	Camera_Min_Y_pos-Camera_Boundaries(a2),d1	; prevent camera from going any further up
	bra.s	.doScroll
; ===========================================================================
; loc_D84A:
.scrollDown_max:
	ext.l	d1
	asl.l	#8,d1		; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
	add.l	(a1),d1		; add the two, getting the new Camera_Y_pos value
	swap	d1		; actual Y-coordinate is now the low word
; loc_D852:
.scrollDown:
	cmp.w	Camera_Max_Y_pos-Camera_Boundaries(a2),d1	; is the new position greater than the maximum Y pos?
	blt.s	.doScroll	; if not, branch
	subi.w	#$800,d1
	bcs.s	.maxYPosReached
	subi.w	#$800,(a1)
	bra.s	.doScroll
; ===========================================================================
; loc_D864:
.maxYPosReached:
	move.w	Camera_Max_Y_pos-Camera_Boundaries(a2),d1	; prevent camera from going any further down
; loc_D868:
.doScroll:
	move.w	(a1),d4		; get old pos (used by SetVertiScrollFlags)
	swap	d1		; actual Y-coordinate is now the high word, as Camera_Y_pos expects it
	move.l	d1,d3
	sub.l	(a1),d3
	ror.l	#8,d3
	move.w	d3,(a4)		; set difference between old and new positions
	move.l	d1,(a1)		; set new camera Y pos
	rts
; End of function ScrollVerti

; ---------------------------------------------------------------------------
; Subroutine to set vertical scroll flags
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


SetVertiScrollFlags:
	move.w	(a1),d0		; get camera Y pos
	andi.w	#$10,d0
	move.b	(a2),d1
	eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
	bne.s	++		; if not, branch
	eori.b	#$10,(a2)
	move.w	(a1),d0		; get camera Y pos
	sub.w	d4,d0		; subtract old camera Y pos
	bpl.s	+		; branch if the camera has scrolled down
	bset	#scroll_flag_fg_up,(a3)	; set moving up in level bit
	rts
; ===========================================================================
+
	bset	#scroll_flag_fg_down,(a3)	; set moving down in level bit
+
	rts
; End of function SetVertiScrollFlags


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; d4 is horizontal, d5 vertical, derived from $FFFFEEB0 & $FFFFEEB2 respectively

;sub_D89A: ;Hztl_Vrtc_Bg_Deformation:
SetHorizVertiScrollFlagsBG: ; used by lev2, MTZ, HTZ, CPZ, DEZ, SCZ, Minimal
	move.l	(Camera_BG_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0	; add x-shift for this frame
	move.l	d0,(Camera_BG_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG).w,d3
	eor.b	d3,d1
	bne.s	++
	eori.b	#$10,(Horiz_block_crossed_flag_BG).w
	sub.l	d2,d0
	bpl.s	+
	bset	#scroll_flag_bg1_left,(Scroll_flags_BG).w
	bra.s	++
; ===========================================================================
+
	bset	#scroll_flag_bg1_right,(Scroll_flags_BG).w
+
	move.l	(Camera_BG_Y_pos).w,d3
	move.l	d3,d0
	add.l	d5,d0	; add y-shift for this frame
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Verti_block_crossed_flag_BG).w,d2
	eor.b	d2,d1
	bne.s	++	; rts
	eori.b	#$10,(Verti_block_crossed_flag_BG).w
	sub.l	d3,d0
	bpl.s	+
	bset	#scroll_flag_bg1_up,(Scroll_flags_BG).w
	rts
; ===========================================================================
+
	bset	#scroll_flag_bg1_down,(Scroll_flags_BG).w
+
	rts
; End of function SetHorizVertiScrollFlagsBG


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D904: ;Horizontal_Bg_Deformation:
SetHorizScrollFlagsBG:	; used by WFZ, HTZ, HPZ
	move.l	(Camera_BG_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0	; add x-shift for this frame
	move.l	d0,(Camera_BG_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG).w
	sub.l	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w
+
	rts
; End of function SetHorizScrollFlagsBG


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D938: ;Vertical_Bg_Deformation1:
SetVertiScrollFlagsBG:		; used by WFZ, HTZ, HPZ, ARZ
	move.l	(Camera_BG_Y_pos).w,d3
	move.l	d3,d0
	add.l	d5,d0	; add y-shift for this frame

;loc_D940: ;Vertical_Bg_Deformation2:
SetVertiScrollFlagsBG2:
	move.l	d0,(Camera_BG_Y_pos).w
	; What this does is set a specific bit in `Scroll_flags_BG`
	; every time the background crosses a vertical 16-pixel boundary
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Verti_block_crossed_flag_BG).w,d2
	eor.b	d2,d1
	bne.s	++	; rts

	eori.b	#$10,(Verti_block_crossed_flag_BG).w
	sub.l	d3,d0
	bpl.s	+
	; Background has moved down
	bset	d6,(Scroll_flags_BG).w
	rts
; ===========================================================================
+
	; Background has moved up
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w
+
	rts
; End of function SetVertiScrollFlagsBG


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D96C: ;ARZ_Bg_Deformation:
SetHorizScrollFlagsBG_ARZ:	; only used by ARZ
	move.l	(Camera_ARZ_BG_X_pos).w,d0
	add.l	d4,d0
	move.l	d0,(Camera_ARZ_BG_X_pos).w
	lea	(Camera_BG_X_pos).w,a1
	move.w	(a1),d2
	move.w	(Camera_ARZ_BG_X_pos).w,d0
	sub.w	d2,d0
	blo.s	+	; Background has moved to the right
	bhi.s	++	; Background has moved to the left
	rts
; ===========================================================================
+
	; Limit the background's scrolling speed (my guess is that
	; the game can't load more than one column of blocks per frame)
	cmpi.w	#-16,d0
	bgt.s	++
	move.w	#-16,d0
	bra.s	++
; ===========================================================================
+
	cmpi.w	#16,d0
	blo.s	+
	move.w	#16,d0
+
	add.w	(a1),d0
	move.w	d0,(a1)
	move.w	d0,d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG).w
	sub.w	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG).w
+
	rts
; End of function SetHorizScrollFlagsBG_ARZ


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_D9C8: ;CPZ_Bg_Deformation:
SetHorizScrollFlagsBG2:	; only used by CPZ
	move.l	(Camera_BG2_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0
	move.l	d0,(Camera_BG2_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG2).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG2).w
	sub.l	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG2).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG2).w
+
	rts
; End of function SetHorizScrollFlagsBG2

; ===========================================================================
; some apparently unused code
;SetHorizScrollFlagsBG3:
	move.l	(Camera_BG3_X_pos).w,d2
	move.l	d2,d0
	add.l	d4,d0
	move.l	d0,(Camera_BG3_X_pos).w
	move.l	d0,d1
	swap	d1
	andi.w	#$10,d1
	move.b	(Horiz_block_crossed_flag_BG3).w,d3
	eor.b	d3,d1
	bne.s	++	; rts
	eori.b	#$10,(Horiz_block_crossed_flag_BG3).w
	sub.l	d2,d0
	bpl.s	+
	bset	d6,(Scroll_flags_BG3).w
	bra.s	++	; rts
; ===========================================================================
+
	addq.b	#1,d6
	bset	d6,(Scroll_flags_BG3).w
+
	rts
; ===========================================================================
; Unused - dead code leftover from S1:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Scroll_flags_BG).w,a2
	lea	(Camera_BG_X_pos).w,a3
	lea	(Level_Layout+$80).w,a4
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
	bsr.w	Draw_BG1
	lea	(Scroll_flags_BG2).w,a2
	lea	(Camera_BG2_X_pos).w,a3
	bra.w	Draw_BG2

; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16544:
AnimateSprite:
	moveq	#0,d0
	move.b	anim(a0),d0		; move animation number to d0
	cmp.b	prev_anim(a0),d0	; is animation set to change?
	beq.s	Anim_Run		; if not, branch
	move.b	d0,prev_anim(a0)	; set prev anim to current current
	move.b	#0,anim_frame(a0)	; reset animation
	move.b	#0,anim_frame_duration(a0)	; reset frame duration
; loc_16560:
Anim_Run:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	Anim_Wait	; if time remains, branch
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),anim_frame_duration(a0)	; load frame duration
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	bmi.s	Anim_End_FF		; if animation is complete, branch
; loc_1657C:
Anim_Next:
	andi.b	#$7F,d0			; clear sign bit
	move.b	d0,mapping_frame(a0)	; load sprite number

	move.b	status(a0),d1								;* match the orientation dictated by the object
	andi.b	#1<<status.npc.x_flip|1<<status.npc.y_flip,d1				;* with the orientation used by the object engine
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),render_flags(a0)	;*
	or.b	d1,render_flags(a0)							;*

	addq.b	#1,anim_frame(a0)	; next frame number
; return_1659A:
Anim_Wait:
	rts
; ===========================================================================
; loc_1659C:
Anim_End_FF:
	addq.b	#1,d0		; is the end flag = $FF?
	bne.s	Anim_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165AC:
Anim_End_FE:
	addq.b	#1,d0	; is the end flag = $FE?
	bne.s	Anim_End_FD	; if not, branch
	move.b	2(a1,d1.w),d0	; read the next byte in the script
	sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
	sub.b	d0,d1
	move.b	1(a1,d1.w),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165C0:
Anim_End_FD:
	addq.b	#1,d0		; is the end flag = $FD?
	bne.s	Anim_End_FC	; if not, branch
	move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
	rts
; ===========================================================================
; loc_165CC:
Anim_End_FC:
	addq.b	#1,d0	; is the end flag = $FC?
	bne.s	Anim_End_FB	; if not, branch
	addq.b	#2,routine(a0)	; jump to next routine
	move.b	#0,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	rts
; ===========================================================================
; loc_165E0:
Anim_End_FB:
	addq.b	#1,d0	; is the end flag = $FB?
	bne.s	Anim_End_FA	; if not, branch
	move.b	#0,anim_frame(a0)	; reset animation
	clr.b	routine_secondary(a0)	; reset 2nd routine counter
	rts
; ===========================================================================
; loc_165F0:
Anim_End_FA:
	addq.b	#1,d0	; is the end flag = $FA?
	bne.s	Anim_End_F9	; if not, branch
	addq.b	#2,routine_secondary(a0)	; jump to next routine
	rts
; ===========================================================================
; loc_165FA:
Anim_End_F9:
	addq.b	#1,d0	; is the end flag = $F9?
	bne.s	Anim_End	; if not, branch
	addq.b	#2,obj89_arrow_routine(a0)
; return_16602:
Anim_End:
	rts
; End of function AnimateSprite

; ---------------------------------------------------------------------------
; Subroutine to change global object animation variables (like rings)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4B64:
ChangeRingFrame:
	subq.b	#1,(Logspike_anim_counter).w
	bpl.s	+
	move.b	#$B,(Logspike_anim_counter).w
	subq.b	#1,(Logspike_anim_frame).w ; animate unused log spikes
	andi.b	#7,(Logspike_anim_frame).w
+
	subq.b	#1,(Rings_anim_counter).w
	bpl.s	+
	move.b	#7,(Rings_anim_counter).w
	addq.b	#1,(Rings_anim_frame).w ; animate rings in the level (obj25)
	andi.b	#3,(Rings_anim_frame).w
+
	subq.b	#1,(Unknown_anim_counter).w
	bpl.s	+
	move.b	#7,(Unknown_anim_counter).w
	addq.b	#1,(Unknown_anim_frame).w ; animate nothing (deleted special stage object is my best guess)
	cmpi.b	#6,(Unknown_anim_frame).w
	blo.s	+
	move.b	#0,(Unknown_anim_frame).w
+
	tst.b	(Ring_spill_anim_counter).w
	beq.s	+	; rts
	moveq	#0,d0
	move.b	(Ring_spill_anim_counter).w,d0
	add.w	(Ring_spill_anim_accum).w,d0
	move.w	d0,(Ring_spill_anim_accum).w
	rol.w	#7,d0
	andi.w	#3,d0
	move.b	d0,(Ring_spill_anim_frame).w ; animate scattered rings (obj37)
	subq.b	#1,(Ring_spill_anim_counter).w
+
	rts
; End of function ChangeRingFrame




; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

nosignpost macro actid
	cmpi.w	#actid,(Current_ZoneAndAct).w
	beq.ATTRIBUTE	+	; rts
    endm

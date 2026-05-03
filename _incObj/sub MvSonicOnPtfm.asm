; Subroutine to change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; loc_19B92:

MvSonicOnPtfm:
	move.w	y_pos(a0),d0
	sub.w	d3,d0
	bra.s	loc_19BA2
; ===========================================================================
	; a couple lines of unused/leftover/dead code from Sonic 1 ; a0=object
	move.w	y_pos(a0),d0
	subi.w	#9,d0

loc_19BA2:
	tst.b	obj_control(a1)
	bmi.s	return_19BCA
	cmpi.b	#6,routine(a1)
	bhs.s	return_19BCA
	tst.w	(Debug_placement_mode).w
	bne.s	return_19BCA
	moveq	#0,d1
	move.b	y_radius(a1),d1
	sub.w	d1,d0
	move.w	d0,y_pos(a1)
	sub.w	x_pos(a0),d2
	sub.w	d2,x_pos(a1)

return_19BCA:
	rts
; ===========================================================================
;loc_19BCC:
MvSonicOnSlope:
	btst	#status.player.on_object,status(a1)
	beq.s	return_19C0C
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	lsr.w	#1,d0
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_19BEC
	not.w	d0
	add.w	d1,d0

loc_19BEC:
	move.b	(a2,d0.w),d1
	ext.w	d1
	move.w	y_pos(a0),d0
	sub.w	d1,d0
	moveq	#0,d1
	move.b	y_radius(a1),d1
	sub.w	d1,d0
	move.w	d0,y_pos(a1)
	sub.w	x_pos(a0),d2
	sub.w	d2,x_pos(a1)

return_19C0C:
	rts
; ===========================================================================
; unused/dead code.
; loc_19C0E:
MvSonicOnDoubleSlope:
	btst	#status.player.on_object,status(a1)
	beq.s	return_19C0C
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_19C2C
	not.w	d0
	add.w	d1,d0

loc_19C2C:
	andi.w	#$FFFE,d0
	bra.s	loc_19BEC

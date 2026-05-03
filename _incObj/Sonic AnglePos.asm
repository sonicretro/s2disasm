; ---------------------------------------------------------------------------
; Subroutine to change Sonic's angle & position as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1E234: Sonic_AnglePos:
AnglePos:
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	move.b	top_solid_bit(a0),d5
	btst	#status.player.on_object,status(a0)
	beq.s	+
	moveq	#0,d0
	move.b	d0,(Primary_Angle).w
	move.b	d0,(Secondary_Angle).w
	rts
; ---------------------------------------------------------------------------
+	moveq	#3,d0
	move.b	d0,(Primary_Angle).w
	move.b	d0,(Secondary_Angle).w
	move.b	angle(a0),d0
	addi.b	#$20,d0
	bpl.s	loc_1E286
	move.b	angle(a0),d0
	bpl.s	+
	subq.b	#1,d0
+
	addi.b	#$20,d0
	bra.s	loc_1E292
; ---------------------------------------------------------------------------
loc_1E286:
	move.b	angle(a0),d0
	bpl.s	loc_1E28E
	addq.b	#1,d0

loc_1E28E:
	addi.b	#$1F,d0

loc_1E292:
	andi.b	#$C0,d0
	cmpi.b	#$40,d0
	beq.w	Sonic_WalkVertL
	cmpi.b	#$80,d0
	beq.w	Sonic_WalkCeiling
	cmpi.b	#$C0,d0
	beq.w	Sonic_WalkVertR
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d3
	lea	(Primary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindFloor
	move.w	d1,-(sp)
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	move.b	x_radius(a0),d0
	ext.w	d0
	neg.w	d0
	add.w	d0,d3
	lea	(Secondary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindFloor
	move.w	(sp)+,d0
	bsr.w	Sonic_Angle
	tst.w	d1
	beq.s	return_1E31C
	bpl.s	loc_1E31E
	cmpi.w	#-$E,d1
	blt.s	return_1E31C
	add.w	d1,y_pos(a0)

return_1E31C:
	rts
; ===========================================================================

loc_1E31E:
	mvabs.b	x_vel(a0),d0
	addq.b	#4,d0
	cmpi.b	#$E,d0
	blo.s	+
	move.b	#$E,d0
+
	cmp.b	d0,d1
	bgt.s	loc_1E33C

loc_1E336:
	add.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_1E33C:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E336
	bset	#status.player.in_air,status(a0)
	bclr	#status.player.pushing,status(a0)
	move.b	#AniIDSonAni_Run,prev_anim(a0)	; Force character's animation to restart
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to change Sonic's angle as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1E356:
Sonic_Angle:
	move.b	(Secondary_Angle).w,d2
	cmp.w	d0,d1
	ble.s	+
	move.b	(Primary_Angle).w,d2
	move.w	d0,d1
+
	btst	#0,d2
	bne.s	loc_1E380
	move.b	d2,d0
	sub.b	angle(a0),d0
	bpl.s	+
	neg.b	d0
+
	cmpi.b	#$20,d0
	bhs.s	loc_1E380
	move.b	d2,angle(a0)
	rts
; ===========================================================================

loc_1E380:
	move.b	angle(a0),d2
	addi.b	#$20,d2
	andi.b	#$C0,d2
	move.b	d2,angle(a0)
	rts
; End of function Sonic_Angle

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to his right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1E392:
Sonic_WalkVertR:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	neg.w	d0
	add.w	d0,d2
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d3
	lea	(Primary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindWall
	move.w	d1,-(sp)
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d3
	lea	(Secondary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindWall
	move.w	(sp)+,d0
	bsr.w	Sonic_Angle
	tst.w	d1
	beq.s	return_1E400
	bpl.s	loc_1E402
	cmpi.w	#-$E,d1
	blt.s	return_1E400
	add.w	d1,x_pos(a0)

return_1E400:
	rts
; ===========================================================================

loc_1E402:
	mvabs.b	y_vel(a0),d0
	addq.b	#4,d0
	cmpi.b	#$E,d0
	blo.s	+
	move.b	#$E,d0
+
	cmp.b	d0,d1
	bgt.s	loc_1E420

loc_1E41A:
	add.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_1E420:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E41A
	bset	#status.player.in_air,status(a0)
	bclr	#status.player.pushing,status(a0)
	move.b	#AniIDSonAni_Run,prev_anim(a0)	; Force character's animation to restart
	rts
; ===========================================================================
;loc_1E43A
Sonic_WalkCeiling:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2
	eori.w	#$F,d2
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d3
	lea	(Primary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$800,d6
	bsr.w	FindFloor
	move.w	d1,-(sp)
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2
	eori.w	#$F,d2
	move.b	x_radius(a0),d0
	ext.w	d0
	sub.w	d0,d3
	lea	(Secondary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$800,d6
	bsr.w	FindFloor
	move.w	(sp)+,d0
	bsr.w	Sonic_Angle
	tst.w	d1
	beq.s	return_1E4AE
	bpl.s	loc_1E4B0
	cmpi.w	#-$E,d1
	blt.s	return_1E4AE
	sub.w	d1,y_pos(a0)

return_1E4AE:
	rts
; ===========================================================================

loc_1E4B0:
	mvabs.b	x_vel(a0),d0
	addq.b	#4,d0
	cmpi.b	#$E,d0
	blo.s	+
	move.b	#$E,d0
+
	cmp.b	d0,d1
	bgt.s	loc_1E4CE

loc_1E4C8:
	sub.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_1E4CE:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E4C8
	bset	#status.player.in_air,status(a0)
	bclr	#status.player.pushing,status(a0)
	move.b	#AniIDSonAni_Run,prev_anim(a0)	; Force character's animation to restart
	rts
; ===========================================================================
;loc_1E4E8
Sonic_WalkVertL:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d3
	eori.w	#$F,d3
	lea	(Primary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$400,d6
	bsr.w	FindWall
	move.w	d1,-(sp)
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d3
	eori.w	#$F,d3
	lea	(Secondary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$400,d6
	bsr.w	FindWall
	move.w	(sp)+,d0
	bsr.w	Sonic_Angle
	tst.w	d1
	beq.s	return_1E55C
	bpl.s	loc_1E55E
	cmpi.w	#-$E,d1
	blt.s	return_1E55C
	sub.w	d1,x_pos(a0)

return_1E55C:
	rts
; ===========================================================================

loc_1E55E:
	mvabs.b	y_vel(a0),d0
	addq.b	#4,d0
	cmpi.b	#$E,d0
	blo.s	+
	move.b	#$E,d0
+
	cmp.b	d0,d1
	bgt.s	loc_1E57C

loc_1E576:
	sub.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_1E57C:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E576
	bset	#status.player.in_air,status(a0)
	bclr	#status.player.pushing,status(a0)
	move.b	#AniIDSonAni_Run,prev_anim(a0)	; Force character's animation to restart
	rts

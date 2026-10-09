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
	beq.s	+ 	; branch if Sonic isn't on a platform
	moveq	#0,d0
	move.b	d0,(Primary_Angle).w 	; clear angle hotspots
	move.b	d0,(Secondary_Angle).w
	rts
; ---------------------------------------------------------------------------
+	moveq	#3,d0
	move.b	d0,(Primary_Angle).w
	move.b	d0,(Secondary_Angle).w
	move.b	angle(a0),d0 ; get last angle
	addi.b	#$20,d0
	bpl.s	loc_1E286 	; branch if angle is (generally) flat or left vertical
	move.b	angle(a0),d0
	bpl.s	+		; branch if angle is between $60 and $7F
	subq.b	#1,d0	; subtract 1 if $80-$DF
+
	addi.b	#$20,d0	; d0 = angle + ($1F or $20)
	bra.s	loc_1E292
; ---------------------------------------------------------------------------
loc_1E286:
	move.b	angle(a0),d0
	bpl.s	loc_1E28E 	; branch if angle is between 0 and $60
	addq.b	#1,d0 		; add 1 if $E0-$FF

loc_1E28E:
	addi.b	#$1F,d0 	; d0 = angle + ($1F or $20)

loc_1E292:
	andi.b	#$C0,d0 			; read only bits 6-7 of angle
	cmpi.b	#$40,d0
	beq.w	Sonic_WalkVertL 	; branch if on left vertical
	cmpi.b	#$80,d0
	beq.w	Sonic_WalkCeiling 	; branch if on ceiling
	cmpi.b	#$C0,d0
	beq.w	Sonic_WalkVertR		; branch if on right vertical
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2 				; d2 = y pos of bottom edge of Sonic
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d3				; d3 = x pos of right edge of Sonic
	lea	(Primary_Angle).w,a4	; write angle here
	movea.w	#$10,a3				; tile height
	move.w	#0,d6
	bsr.w	FindFloor
	move.w	d1,-(sp)			; save d1 (distance to floor) to stack
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2				; d2 = y pos of bottom edge of Sonic
	move.b	x_radius(a0),d0
	ext.w	d0
	neg.w	d0
	add.w	d0,d3				; d3 = x pos of left edge of Sonic
	lea	(Secondary_Angle).w,a4 	; write angle here
	movea.w	#$10,a3 			; tile height
	move.w	#0,d6
	bsr.w	FindFloor 			; d1 = distance to floor left side
	move.w	(sp)+,d0			; d0 = distance to floor right side
	bsr.w	Sonic_Angle			; update angle
	tst.w	d1
	beq.s	return_1E31C		; branch if Sonic is 0px from floor
	bpl.s	loc_1E31E			; branch if Sonic is above floor
	cmpi.w	#-$E,d1
	blt.s	return_1E31C 		; branch if Sonic is > 14px below floor
	add.w	d1,y_pos(a0)		; align to floor

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
	add.w	d1,y_pos(a0)		; align to floor
	rts
; ===========================================================================

loc_1E33C:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E336	; branch if Sonic is on a spinning disk (unused)
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
	move.b	(Secondary_Angle).w,d2	; use left side angle
	cmp.w	d0,d1
	ble.s	+ 	; branch if floor is nearer on left side
	move.b	(Primary_Angle).w,d2	; use right side angle
	move.w	d0,d1	; use distance of right side
+
	btst	#0,d2
	bne.s	loc_1E380	; branch if bit 0 of angle is set
	move.b	d2,d0
	sub.b	angle(a0),d0
	bpl.s	+
	neg.b	d0
+
	cmpi.b	#$20,d0
	bhs.s	loc_1E380
	move.b	d2,angle(a0)	; update angle
	rts
; ===========================================================================

loc_1E380:
	move.b	angle(a0),d2
	addi.b	#$20,d2
	andi.b	#$C0,d2	; snap to nearest 90 degree angle
	move.b	d2,angle(a0)	; update angle
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
	add.w	d0,d2	; d2 = y pos of upper edge of Sonic (i.e. his front or back)
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d3	; d3 = x pos of bottom edge of Sonic (i.e. his feet)
	lea	(Primary_Angle).w,a4	; write angle here
	movea.w	#$10,a3	; tile width
	move.w	#0,d6
	bsr.w	FindWall
	move.w	d1,-(sp)	; save d1 (distance to wall) to stack
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d2	; d2 = y pos of lower edge of Sonic (i.e. his front or back)
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d3
	lea	(Secondary_Angle).w,a4 ; write angle here
	movea.w	#$10,a3	; tile width
	move.w	#0,d6
	bsr.w	FindWall	; d1 = distance to wall lower side
	move.w	(sp)+,d0	; d0 = distance to wall upper side
	bsr.w	Sonic_Angle	; update angle
	tst.w	d1
	beq.s	return_1E400	; branch if Sonic is 0px from wall
	bpl.s	loc_1E402	; branch if Sonic is outside wall
	cmpi.w	#-$E,d1
	blt.s	return_1E400	; branch if Sonic is > 14px inside wall
	add.w	d1,x_pos(a0)	; align to wall

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
	bne.s	loc_1E41A	; branch if Sonic is on a spinning disk (unused)
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
	sub.w	d0,d2	; d2 = y pos of top edge of Sonic (i.e. his feet)
	eori.w	#$F,d2	; add some amount
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d3	; d3 = x pos of right edge of Sonic
	lea	(Primary_Angle).w,a4	; write angle here
	movea.w	#-$10,a3	; tile height
	move.w	#$800,d6	; yflip tile
	bsr.w	FindFloor
	move.w	d1,-(sp)	; save d1 (distance to ceiling) to stack
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2	; d2 = y pos of top edge of Sonic (i.e. his feet)
	eori.w	#$F,d2
	move.b	x_radius(a0),d0
	ext.w	d0
	sub.w	d0,d3	; d3 = x pos of left edge of Sonic
	lea	(Secondary_Angle).w,a4	; write angle here
	movea.w	#-$10,a3	; tile height
	move.w	#$800,d6	; yflip tile
	bsr.w	FindFloor	; d1 = distance to ceiling left side
	move.w	(sp)+,d0	; d0 = distance to ceiling right side
	bsr.w	Sonic_Angle	; update angle
	tst.w	d1
	beq.s	return_1E4AE	; branch if Sonic is 0px from ceiling
	bpl.s	loc_1E4B0	; branch if Sonic is below ceiling
	cmpi.w	#-$E,d1
	blt.s	return_1E4AE	; branch if Sonic is > 14px inside ceiling
	sub.w	d1,y_pos(a0)	; align to ceiling

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
	sub.w	d1,y_pos(a0)	; align to ceiling
	rts
; ===========================================================================

loc_1E4CE:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E4C8	; branch if Sonic is on a spinning disk (unused)
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
	sub.w	d0,d2	; d2 = y pos of upper edge of Sonic (i.e. his front or back)
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d3	; d3 = x pos of bottom edge of Sonic (i.e. his feet)
	eori.w	#$F,d3	; add some amount
	lea	(Primary_Angle).w,a4	; write angle here
	movea.w	#-$10,a3	; tile width
	move.w	#$400,d6	; xflip tile
	bsr.w	FindWall
	move.w	d1,-(sp)	; save d1 (distance to wall) to stack
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	add.w	d0,d2	; d2 = y pos of lower edge of Sonic (i.e. his front or back)
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d3	; d3 = x pos of bottom edge of Sonic (i.e. his feet)
	eori.w	#$F,d3
	lea	(Secondary_Angle).w,a4	; write angle here
	movea.w	#-$10,a3	; tile width
	move.w	#$400,d6	; xflip tile
	bsr.w	FindWall	; d1 = distance to wall lower side
	move.w	(sp)+,d0	; d0 = distance to wall upper side
	bsr.w	Sonic_Angle	; update angle
	tst.w	d1
	beq.s	return_1E55C	; branch if Sonic is 0px from wall
	bpl.s	loc_1E55E	; branch if Sonic is outside wall
	cmpi.w	#-$E,d1
	blt.s	return_1E55C	; branch if Sonic is > 14px inside wall
	sub.w	d1,x_pos(a0)	; align to wall

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
	sub.w	d1,x_pos(a0)	; align to wall
	rts
; ===========================================================================

loc_1E57C:
	tst.b	stick_to_convex(a0)
	bne.s	loc_1E576	; branch if Sonic is on a spinning disk (unused)
	bset	#status.player.in_air,status(a0)
	bclr	#status.player.pushing,status(a0)
	move.b	#AniIDSonAni_Run,prev_anim(a0)	; Force character's animation to restart
	rts
; ===========================================================================

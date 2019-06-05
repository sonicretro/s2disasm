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
	btst	#3,status(a0)
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
	bset	#1,status(a0)
	bclr	#5,status(a0)
	move.b	#AniIDSonAni_Run,next_anim(a0)
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
	bset	#1,status(a0)
	bclr	#5,status(a0)
	move.b	#AniIDSonAni_Run,next_anim(a0)
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
	bset	#1,status(a0)
	bclr	#5,status(a0)
	move.b	#AniIDSonAni_Run,next_anim(a0)
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
	bset	#1,status(a0)
	bclr	#5,status(a0)
	move.b	#AniIDSonAni_Run,next_anim(a0)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to find which tile is in the specified location
; d2 = y_pos
; d3 = x_pos
; returns relevant block ID in (a1)
; a1 is pointer to block in chunk table
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1E596: Floor_ChkTile:
Find_Tile:
	move.w	d2,d0	; y_pos
	add.w	d0,d0
	andi.w	#$F00,d0	; rounded 2*y_pos
	move.w	d3,d1	; x_pos
	lsr.w	#3,d1
	move.w	d1,d4
	lsr.w	#4,d1	; x_pos/128 = x_of_chunk
	andi.w	#$7F,d1
	add.w	d1,d0	; d0 is relevant chunk ID now
	moveq	#-1,d1
	clr.w	d1		; d1 is now $FFFF0000 = Chunk_Table
	lea	(Level_Layout).w,a1
	move.b	(a1,d0.w),d1	; move 128*128 chunk ID to d1
	add.w	d1,d1
	move.w	word_1E5D0(pc,d1.w),d1
	move.w	d2,d0	; y_pos
	andi.w	#$70,d0
	add.w	d0,d1
	andi.w	#$E,d4	; x_pos/8
	add.w	d4,d1
	movea.l	d1,a1	; address of block ID
	rts
; ===========================================================================
; precalculated values for Find_Tile
; (Sonic 1 calculated it every time instead of using a table)
word_1E5D0:
c := 0
	rept 256
		dc.w	c
c := c+$80
	endm
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Scans vertically for up to 2 16x16 blocks to find solid ground or ceiling.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; d6 = $0000 for no flip, $0800 for vertical flip
; a3 = delta-y for next location to check if current one is empty
; a4 = pointer to angle buffer
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in (a4)

; loc_1E7D0:
FindFloor:
	bsr.w	Find_Tile
	move.w	(a1),d0
	move.w	d0,d4
	andi.w	#$3FF,d0
	beq.s	loc_1E7E2
	btst	d5,d4
	bne.s	loc_1E7F0

loc_1E7E2:
	add.w	a3,d2
	bsr.w	FindFloor2
	sub.w	a3,d2
	addi.w	#$10,d1
	rts
; ===========================================================================

loc_1E7F0:	; block has some solidity
	movea.l	(Collision_addr).w,a2	; pointer to collision data, i.e. blockID -> collisionID array
	move.b	(a2,d0.w),d0	; get collisionID
	andi.w	#$FF,d0
	beq.s	loc_1E7E2
	lea	(ColCurveMap).l,a2
	move.b	(a2,d0.w),(a4)	; get angle from AngleMap --> (a4)
	lsl.w	#4,d0
	move.w	d3,d1	; x_pos
	btst	#$A,d4	; adv.blockID in d4 - X flipping
	beq.s	+
	not.w	d1
	neg.b	(a4)
+
	btst	#$B,d4	; Y flipping
	beq.s	+
	addi.b	#$40,(a4)
	neg.b	(a4)
	subi.b	#$40,(a4)
+
	andi.w	#$F,d1	; x_pos (mod 16)
	add.w	d0,d1	; d0 = 16*blockID -> offset in ColArray to look up
	lea	(ColArray).l,a2
	move.b	(a2,d1.w),d0	; heigth from ColArray
	ext.w	d0
	eor.w	d6,d4
	btst	#$B,d4	; Y flipping
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	beq.s	loc_1E7E2	; no collision
	bmi.s	loc_1E85E
	cmpi.b	#$10,d0
	beq.s	loc_1E86A
	move.w	d2,d1
	andi.w	#$F,d1
	add.w	d1,d0
	move.w	#$F,d1
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1E85E:
	move.w	d2,d1
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	loc_1E7E2

loc_1E86A:
	sub.w	a3,d2
	bsr.w	FindFloor2
	add.w	a3,d2
	subi.w	#$10,d1
	rts
; End of function FindFloor


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Checks a 16x16 block to find solid ground or ceiling.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; d6 = $0000 for no flip, $0800 for vertical flip
; a4 = pointer to angle buffer
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in (a4)

; loc_1E878:
FindFloor2:
	bsr.w	Find_Tile
	move.w	(a1),d0
	move.w	d0,d4
	andi.w	#$3FF,d0
	beq.s	loc_1E88A
	btst	d5,d4
	bne.s	loc_1E898

loc_1E88A:
	move.w	#$F,d1
	move.w	d2,d0
	andi.w	#$F,d0
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1E898:
	movea.l	(Collision_addr).w,a2
	move.b	(a2,d0.w),d0
	andi.w	#$FF,d0
	beq.s	loc_1E88A
	lea	(ColCurveMap).l,a2
	move.b	(a2,d0.w),(a4)
	lsl.w	#4,d0
	move.w	d3,d1
	btst	#$A,d4
	beq.s	+
	not.w	d1
	neg.b	(a4)
+
	btst	#$B,d4
	beq.s	+
	addi.b	#$40,(a4)
	neg.b	(a4)
	subi.b	#$40,(a4)
+
	andi.w	#$F,d1
	add.w	d0,d1
	lea	(ColArray).l,a2
	move.b	(a2,d1.w),d0
	ext.w	d0
	eor.w	d6,d4
	btst	#$B,d4
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	beq.s	loc_1E88A
	bmi.s	loc_1E900
	move.w	d2,d1
	andi.w	#$F,d1
	add.w	d1,d0
	move.w	#$F,d1
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1E900:
	move.w	d2,d1
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	loc_1E88A
	not.w	d1
	rts
; ===========================================================================

; Checks a 16x16 block to find solid ground or ceiling. May check an additional
; 16x16 block up for ceilings.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; d6 = $0000 for no flip, $0800 for vertical flip
; a4 = pointer to angle buffer
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in (a4)

; loc_1E910: Obj_CheckInFloor:
Ring_FindFloor:
	bsr.w	Find_Tile
	move.w	(a1),d0
	move.w	d0,d4
	andi.w	#$3FF,d0
	beq.s	loc_1E922
	btst	d5,d4
	bne.s	loc_1E928

loc_1E922:
	move.w	#$10,d1
	rts
; ===========================================================================

loc_1E928:
	movea.l	(Collision_addr).w,a2
	move.b	(a2,d0.w),d0
	andi.w	#$FF,d0
	beq.s	loc_1E922
	lea	(ColCurveMap).l,a2
	move.b	(a2,d0.w),(a4)
	lsl.w	#4,d0
	move.w	d3,d1
	btst	#$A,d4
	beq.s	+
	not.w	d1
	neg.b	(a4)
+
	btst	#$B,d4
	beq.s	+
	addi.b	#$40,(a4)
	neg.b	(a4)
	subi.b	#$40,(a4)
+
	andi.w	#$F,d1
	add.w	d0,d1
	lea	(ColArray).l,a2
	move.b	(a2,d1.w),d0
	ext.w	d0
	eor.w	d6,d4
	btst	#$B,d4
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	beq.s	loc_1E922
	bmi.s	loc_1E996
	cmpi.b	#$10,d0
	beq.s	loc_1E9A2
	move.w	d2,d1
	andi.w	#$F,d1
	add.w	d1,d0
	move.w	#$F,d1
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1E996:
	move.w	d2,d1
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	loc_1E922

loc_1E9A2:
	sub.w	a3,d2
	bsr.w	FindFloor2
	add.w	a3,d2
	subi.w	#$10,d1
	rts
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Scans horizontally for up to 2 16x16 blocks to find solid walls.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; d6 = $0000 for no flip, $0400 for horizontal flip
; a3 = delta-x for next location to check if current one is empty
; a4 = pointer to angle buffer
; returns relevant block ID in (a1)
; returns distance to left/right in d1
; returns angle in (a4)

; loc_1E9B0:
FindWall:
	bsr.w	Find_Tile
	move.w	(a1),d0
	move.w	d0,d4
	andi.w	#$3FF,d0	; plain blockID
	beq.s	loc_1E9C2	; no collision
	btst	d5,d4
	bne.s	loc_1E9D0

loc_1E9C2:
	add.w	a3,d3
	bsr.w	FindWall2
	sub.w	a3,d3
	addi.w	#$10,d1
	rts
; ===========================================================================

loc_1E9D0:
	movea.l	(Collision_addr).w,a2
	move.b	(a2,d0.w),d0
	andi.w	#$FF,d0	; relevant collisionArrayEntry
	beq.s	loc_1E9C2
	lea	(ColCurveMap).l,a2
	move.b	(a2,d0.w),(a4)
	lsl.w	#4,d0	; offset in collision array
	move.w	d2,d1	; y
	btst	#$B,d4	; y-mirror?
	beq.s	+
	not.w	d1
	addi.b	#$40,(a4)
	neg.b	(a4)
	subi.b	#$40,(a4)
+
	btst	#$A,d4	; x-mirror?
	beq.s	+
	neg.b	(a4)
+
	andi.w	#$F,d1	; y
	add.w	d0,d1	; line to look up
	lea	(ColArray2).l,a2	; rotated collision array
	move.b	(a2,d1.w),d0	; collision value
	ext.w	d0
	eor.w	d6,d4	; set x-flip flag if from the right
	btst	#$A,d4	; x-mirror?
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	beq.s	loc_1E9C2
	bmi.s	loc_1EA3E
	cmpi.b	#$10,d0
	beq.s	loc_1EA4A
	move.w	d3,d1	; x
	andi.w	#$F,d1
	add.w	d1,d0
	move.w	#$F,d1
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1EA3E:
	move.w	d3,d1
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	loc_1E9C2	; no collision

loc_1EA4A:
	sub.w	a3,d3
	bsr.w	FindWall2
	add.w	a3,d3
	subi.w	#$10,d1
	rts
; End of function FindWall


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Checks a 16x16 blocks to find solid walls.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; d6 = $0000 for no flip, $0400 for horizontal flip
; a4 = pointer to angle buffer
; returns relevant block ID in (a1)
; returns distance to left/right in d1
; returns angle in (a4)

; loc_1EA58:
FindWall2:
	bsr.w	Find_Tile
	move.w	(a1),d0
	move.w	d0,d4
	andi.w	#$3FF,d0
	beq.s	loc_1EA6A
	btst	d5,d4
	bne.s	loc_1EA78

loc_1EA6A:
	move.w	#$F,d1
	move.w	d3,d0
	andi.w	#$F,d0
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1EA78:
	movea.l	(Collision_addr).w,a2
	move.b	(a2,d0.w),d0
	andi.w	#$FF,d0
	beq.s	loc_1EA6A
	lea	(ColCurveMap).l,a2
	move.b	(a2,d0.w),(a4)
	lsl.w	#4,d0
	move.w	d2,d1
	btst	#$B,d4
	beq.s	+
	not.w	d1
	addi.b	#$40,(a4)
	neg.b	(a4)
	subi.b	#$40,(a4)
+
	btst	#$A,d4
	beq.s	+
	neg.b	(a4)
+
	andi.w	#$F,d1
	add.w	d0,d1
	lea	(ColArray2).l,a2
	move.b	(a2,d1.w),d0
	ext.w	d0
	eor.w	d6,d4
	btst	#$A,d4
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	beq.s	loc_1EA6A
	bmi.s	loc_1EAE0
	move.w	d3,d1
	andi.w	#$F,d1
	add.w	d1,d0
	move.w	#$F,d1
	sub.w	d0,d1
	rts
; ===========================================================================

loc_1EAE0:
	move.w	d3,d1
	andi.w	#$F,d1
	add.w	d1,d0
	bpl.w	loc_1EA6A
	not.w	d1
	rts
; End of function FindWall2

; ---------------------------------------------------------------------------
; The subroutine appears to convert the collision array from an unknown
; 'raw' format to its current format, and write it to ROM, overwritting
; the original. This doesn't work on standard read-only cartridges, and
; would instead require a special dev cartridge.
; This subroutine exists in Sonic 1 as well, but was oddly changed in
; the S2 Nick Arcade prototype to just handle loading GHZ's collision
; instead (though it too is dummied out, hence collision being broken).
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; return_1EAF0: FloorLog_Unk:
ConvertCollisionArray:
	rts
; ---------------------------------------------------------------------------
	lea	(ColArray).l,a1	; Source location of 'raw' collision array
	lea	(ColArray).l,a2	; Destinatation of converted collision array (overwrites the original)

	move.w	#$100-1,d3	; Number of blocks in collision array
.blockLoop:
	moveq	#16,d5		; Start on the 16th bit (the leftmost pixel)

	move.w	#16-1,d2	; Width of a block in pixels
.columnLoop:
	moveq	#0,d4

	; It seems the 'raw' format stored the collision of each pixel in rows.
	; This block of code changes it from rows to columns, so each word contains
	; a bit for each pixel in a column.
	move.w	#16-1,d1	; Height of a block in pixels
.rowLoop:
	move.w	(a1)+,d0	; Get row of collision bits
	lsr.l	d5,d0		; Push the selected bit of this row into the 'eXtend' flag
	addx.w	d4,d4		; Shift d4 to the left, and insert the selected bit into bit 0
	dbf	d1,.rowLoop	; Loop for each row of pixels in a block

	move.w	d4,(a2)+	; Store column of collision bits
	suba.w	#2*16,a1	; Back to the start of the block
	subq.w	#1,d5		; Get next bit in the row
	dbf	d2,.columnLoop	; Loop for each column of pixels in a block

	adda.w	#2*16,a1	; Next block
	dbf	d3,.blockLoop	; Loop for each block in the collision array

	lea	(ColArray).l,a1
	lea	(ColArray2).l,a2	; Write converted collision array to location of rotated collison array
	bsr.s	.convertArrayToStandardFormat
	lea	(ColArray).l,a1
	lea	(ColArray).l,a2		; Write converted collision array to location of normal collison array

; loc_1EB46: FloorLog_Unk2:
.convertArrayToStandardFormat:
	move.w	#$1000-1,d3	; Size of the collision array

.processCollisionArrayLoop:
	moveq	#0,d2
	move.w	#$F,d1
	move.w	(a1)+,d0	; Get current column of collision pixels
	beq.s	.noCollision	; Branch if there's no collision in this column
	bmi.s	.topPixelSolid	; Branch if top pixel of collision is solid

	; Here we count, starting from the bottom, how many pixels tall
	; the collision in this column is.
.processColumnLoop1:
	lsr.w	#1,d0
	bcc.s	.pixelNotSolid1
	addq.b	#1,d2
.pixelNotSolid1:
	dbf	d1,.processColumnLoop1

	bra.s	.columnProcessed
; ===========================================================================
.topPixelSolid:
	cmpi.w	#$FFFF,d0		; Is entire column solid?
	beq.s	.entireColumnSolid	; Branch if so

	; Here we count, starting from the top, how many pixels tall
	; the collision in this column is (the resulting number is negative).
.processColumnLoop2:
	lsl.w	#1,d0
	bcc.s	.pixelNotSolid2
	subq.b	#1,d2
.pixelNotSolid2:
	dbf	d1,.processColumnLoop2

	bra.s	.columnProcessed
; ===========================================================================
.entireColumnSolid:
	move.w	#16,d0

; loc_1EB78:
.noCollision:
	move.w	d0,d2

; loc_1EB7A:
.columnProcessed:
	move.b	d2,(a2)+	; Store column collision height to ROM
	dbf	d3,.processCollisionArrayLoop

	rts

; End of function ConvertCollisionArray

    if gameRevision<2
	nop
    endif




; ---------------------------------------------------------------------------
; Subroutine to calculate how much space is in front of Sonic or Tails on the ground
; d0 = some input angle
; d1 = output about how many pixels (up to some high enough amount)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EB84: Sonic_WalkSpeed:
CalcRoomInFront:
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	move.b	lrb_solid_bit(a0),d5			; Want walls or ceilings
	move.l	x_pos(a0),d3
	move.l	y_pos(a0),d2
	move.w	x_vel(a0),d1
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d3
	move.w	y_vel(a0),d1
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d2
	swap	d2
	swap	d3
	move.b	d0,(Primary_Angle).w
	move.b	d0,(Secondary_Angle).w
	move.b	d0,d1
	addi.b	#$20,d0
	bpl.s	loc_1EBDC

	move.b	d1,d0
	bpl.s	+
	subq.b	#1,d0
+
	addi.b	#$20,d0
	bra.s	loc_1EBE6
; ---------------------------------------------------------------------------
loc_1EBDC:
	move.b	d1,d0
	bpl.s	+
	addq.b	#1,d0
+
	addi.b	#$1F,d0

loc_1EBE6:
	andi.b	#$C0,d0
	beq.w	CheckFloorDist_Part2		; Player is going mostly down
	cmpi.b	#$80,d0
	beq.w	CheckCeilingDist_Part2		; Player is going mostly up
	andi.b	#$38,d1
	bne.s	+
	addq.w	#8,d2
+
	cmpi.b	#$40,d0
	beq.w	CheckLeftWallDist_Part2		; Player is going mostly left
	bra.w	CheckRightWallDist_Part2	; Player is going mostly right

; End of function CalcRoomInFront


; ---------------------------------------------------------------------------
; Subroutine to calculate how much space is empty above Sonic's/Tails' head
; d0 = input angle perpendicular to the spine
; d1 = output about how many pixels are overhead (up to some high enough amount)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1EC0A:
CalcRoomOverHead:
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	move.b	lrb_solid_bit(a0),d5
	move.b	d0,(Primary_Angle).w
	move.b	d0,(Secondary_Angle).w
	addi.b	#$20,d0
	andi.b	#$C0,d0
	cmpi.b	#$40,d0
	beq.w	CheckLeftCeilingDist
	cmpi.b	#$80,d0
	beq.w	Sonic_CheckCeiling
	cmpi.b	#$C0,d0
	beq.w	CheckRightCeilingDist

; End of function CalcRoomOverHead

; ---------------------------------------------------------------------------
; Subroutine to check if Sonic/Tails is near the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EC4E: Sonic_HitFloor:
Sonic_CheckFloor:
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	move.b	top_solid_bit(a0),d5
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
	sub.w	d0,d3
	lea	(Secondary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindFloor
	move.w	(sp)+,d0
	move.b	#0,d2

loc_1ECC6:
	move.b	(Secondary_Angle).w,d3
	cmp.w	d0,d1
	ble.s	loc_1ECD4
	move.b	(Primary_Angle).w,d3
	exg	d0,d1

loc_1ECD4:
	btst	#0,d3
	beq.s	+
	move.b	d2,d3
+
	rts
; ===========================================================================

	; a bit of unused/dead code here
;CheckFloorDist:
	move.w	y_pos(a0),d2 ; a0=character
	move.w	x_pos(a0),d3

; Checks a 16x16 block to find solid ground. May check an additional
; 16x16 block up for ceilings.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in d3, or zero if angle was odd
;loc_1ECE6:
CheckFloorDist_Part2:
	addi.w	#$A,d2
	lea	(Primary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindFloor
	move.b	#0,d2

; d2 what to use as angle if (Primary_Angle).w is odd
; returns angle in d3, or value in d2 if angle was odd
loc_1ECFE:
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	d2,d3
+
	rts
; ===========================================================================

	; Unused collision checking subroutine

	move.w	x_pos(a0),d3 ; a0=character
	move.w	y_pos(a0),d2
	subq.w	#4,d2
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$D,lrb_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	move.b	lrb_solid_bit(a0),d5
	bsr.w	FindFloor
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	#0,d3
+
	rts

; ===========================================================================
; loc_1ED56:
ChkFloorEdge:
	move.w	x_pos(a0),d3
; loc_1ED5A:
ChkFloorEdge_Part2:
	move.w	y_pos(a0),d2
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a0)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	move.b	top_solid_bit(a0),d5
	bsr.w	FindFloor
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	#0,d3
+
	rts
; ===========================================================================
; Identical to ChkFloorEdge except that this uses a1 instead of a0
;loc_1EDA8:
ChkFloorEdge2:
	move.w	x_pos(a1),d3
	move.w	y_pos(a1),d2
	moveq	#0,d0
	move.b	y_radius(a1),d0
	ext.w	d0
	add.w	d0,d2
	move.l	#Primary_Collision,(Collision_addr).w
	cmpi.b	#$C,top_solid_bit(a1)
	beq.s	+
	move.l	#Secondary_Collision,(Collision_addr).w
+
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	move.b	top_solid_bit(a1),d5
	bsr.w	FindFloor
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	return_1EDF8
	move.b	#0,d3

return_1EDF8:
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine checking if an object should interact with the floor
; (objects such as a monitor Sonic bumps from underneath)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EDFA: ObjHitFloor:
ObjCheckFloorDist:
	move.w	x_pos(a0),d3
	move.w	y_pos(a0),d2
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	moveq	#$C,d5
	bsr.w	FindFloor
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	#0,d3
+
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Collision check used to let the HTZ boss fire attack to hit the ground
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EE30:
FireCheckFloorDist:
	move.w	x_pos(a1),d3
	move.w	y_pos(a1),d2
	move.b	y_radius(a1),d0
	ext.w	d0
	add.w	d0,d2
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	moveq	#$C,d5
	bra.w	FindFloor
; End of function FireCheckFloorDist

; ---------------------------------------------------------------------------
; Collision check used to let scattered rings bounce on the ground
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EE56:
RingCheckFloorDist:
	move.w	x_pos(a0),d3
	move.w	y_pos(a0),d2
	move.b	y_radius(a0),d0
	ext.w	d0
	add.w	d0,d2
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	moveq	#$C,d5
	bra.w	Ring_FindFloor
; End of function RingCheckFloorDist

; ---------------------------------------------------------------------------
; Stores a distance to the nearest wall above Sonic/Tails,
; where "above" = right, into d1
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EE7C:
CheckRightCeilingDist:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	x_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2
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
	move.b	#-$40,d2
	bra.w	loc_1ECC6
; End of function CheckRightCeilingDist

; ---------------------------------------------------------------------------
; Stores a distance to the nearest wall on the right of Sonic/Tails into d1
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Checks a 16x16 block to find solid walls. May check an additional
; 16x16 block up for walls.
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in d3, or zero if angle was odd
; sub_1EEDC:
CheckRightWallDist:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
; loc_1EEE4:
CheckRightWallDist_Part2:
	addi.w	#$A,d3
	lea	(Primary_Angle).w,a4
	movea.w	#$10,a3
	move.w	#0,d6
	bsr.w	FindWall
	move.b	#$C0,d2
	bra.w	loc_1ECFE
; End of function CheckRightWallDist

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EF00: ObjCheckLeftWallDist:
ObjCheckRightWallDist:
	add.w	x_pos(a0),d3
	move.w	y_pos(a0),d2
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#$10,a3
	move.w	#0,d6
	moveq	#$D,d5
	bsr.w	FindWall
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	#-$40,d3
+
	rts
; End of function ObjCheckRightWallDist

; ---------------------------------------------------------------------------
; Stores a distance from Sonic/Tails to the nearest ceiling into d1
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EF2E: Sonic_DontRunOnWalls: CheckCeilingDist:
Sonic_CheckCeiling:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2
	eori.w	#$F,d2 ; flip position upside-down within the current 16x16 block?
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

	move.b	#$80,d2
	bra.w	loc_1ECC6
; End of function Sonic_CheckCeiling

; ===========================================================================
	; a bit of unused/dead code here
;CheckCeilingDist:
	move.w	y_pos(a0),d2 ; a0=character
	move.w	x_pos(a0),d3

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Checks a 16x16 block to find solid ceiling. May check an additional
; 16x16 block up for ceilings.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in d3, or zero if angle was odd
; loc_1EF9E: CheckSlopeDist:
CheckCeilingDist_Part2:
	subi.w	#$A,d2
	eori.w	#$F,d2
	lea	(Primary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$800,d6
	bsr.w	FindFloor
	move.b	#$80,d2
	bra.w	loc_1ECFE
; End of function CheckCeilingDist

; ---------------------------------------------------------------------------
; Stores a distance to the nearest wall above the object into d1
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EFBE: ObjHitCeiling:
ObjCheckCeilingDist:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	moveq	#0,d0
	move.b	y_radius(a0),d0
	ext.w	d0
	sub.w	d0,d2
	eori.w	#$F,d2
	lea	(Primary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$800,d6
	moveq	#$D,d5
	bsr.w	FindFloor
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	#$80,d3
+
	rts
; End of function ObjCheckCeilingDist

; ---------------------------------------------------------------------------
; Stores a distance to the nearest wall above Sonic/Tails,
; where "above" = left, into d1
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1EFF6:
CheckLeftCeilingDist:
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
	move.b	#$40,d2
	bra.w	loc_1ECC6
; End of function CheckLeftCeilingDist

; ---------------------------------------------------------------------------
; Stores a distance to the nearest wall on the left of Sonic/Tails into d1
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Checks a 16x16 block to find solid walls. May check an additional
; 16x16 block up for walls.
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in d3, or zero if angle was odd
; loc_1F05E: Sonic_HitWall:
CheckLeftWallDist:
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
; loc_1F066:
CheckLeftWallDist_Part2:
	subi.w	#$A,d3
	eori.w	#$F,d3
	lea	(Primary_Angle).w,a4
	movea.w	#-$10,a3
	move.w	#$400,d6
	bsr.w	FindWall
	move.b	#$40,d2
	bra.w	loc_1ECFE
; End of function CheckLeftWallDist

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1F086: ObjCheckRightWallDist:
ObjCheckLeftWallDist:
	add.w	x_pos(a0),d3
	move.w	y_pos(a0),d2
	; Engine bug: colliding with left walls is erratic with this function.
	; The cause is this: a missing instruction to flip collision on the found
	; 16x16 block; this one:
	;eori.w	#$F,d3
	lea	(Primary_Angle).w,a4
	move.b	#0,(a4)
	movea.w	#-$10,a3
	move.w	#$400,d6
	moveq	#$D,d5
	bsr.w	FindWall
	move.b	(Primary_Angle).w,d3
	btst	#0,d3
	beq.s	+
	move.b	#$40,d3
+
	rts

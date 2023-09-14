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
    if fixBugs
	; Colliding with left walls is erratic with this function.
	; The cause is this: a missing instruction to flip collision on the found
	; 16x16 block; this one:
	eori.w	#$F,d3
    endif
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

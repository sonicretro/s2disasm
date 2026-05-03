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

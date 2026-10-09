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
	add.w	d0,d1	; d0 = 16*blockID -> offset in ColArrayVertical to look up
	lea	(ColArrayVertical).l,a2
	move.b	(a2,d1.w),d0	; heigth from ColArrayVertical
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
	lea	(ColArrayVertical).l,a2
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
	lea	(ColArrayVertical).l,a2
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
	lea	(ColArrayHorizontal).l,a2	; rotated collision array
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
	lea	(ColArrayHorizontal).l,a2
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

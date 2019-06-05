; ----------------------------------------------------------------------------
; Pseudo-object that manages where rings are placed onscreen
; as you move through the level, and otherwise updates them.
; ----------------------------------------------------------------------------

; loc_16F88:
RingsManager:
	moveq	#0,d0
	move.b	(Rings_manager_routine).w,d0
	move.w	RingsManager_States(pc,d0.w),d0
	jmp	RingsManager_States(pc,d0.w)
; ===========================================================================
; off_16F96:
RingsManager_States:	offsetTable
	offsetTableEntry.w RingsManager_Init	;   0
	offsetTableEntry.w RingsManager_Main	;   2
; ===========================================================================
; loc_16F9A:
RingsManager_Init:
	addq.b	#2,(Rings_manager_routine).w ; => RingsManager_Main
	bsr.w	RingsManager_Setup	; perform initial setup
	lea	(Ring_Positions).w,a1
	move.w	(Camera_X_pos).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4	; no negative values allowed
	bra.s	+
-
	lea	6(a1),a1	; load next ring
+
	cmp.w	2(a1),d4	; is the X pos of the ring < camera X pos?
	bhi.s	-		; if it is, check next ring
	move.w	a1,(Ring_start_addr).w	; set start addresses
	move.w	a1,(Ring_start_addr_P2).w
	addi.w	#320+16,d4	; advance by a screen
	bra.s	+
-
	lea	6(a1),a1	; load next ring
+
	cmp.w	2(a1),d4	; is the X pos of the ring < camera X + 336?
	bhi.s	-		; if it is, check next ring
	move.w	a1,(Ring_end_addr).w	; set end addresses
	move.w	a1,(Ring_end_addr_P2).w
	rts
; ===========================================================================
; loc_16FDE:
RingsManager_Main:
	lea	(Ring_consumption_table).w,a2
	move.w	(a2)+,d1
	subq.w	#1,d1	; are any rings currently being consumed?
	bcs.s	++	; if not, branch

-	move.w	(a2)+,d0	; is there a ring in this slot?
	beq.s	-	; if not, branch
	movea.w	d0,a1	; load ring address
	subq.b	#1,(a1)	; decrement timer
	bne.s	+	; if it's not 0 yet, branch
	move.b	#6,(a1)	; reset timer
	addq.b	#1,1(a1); increment frame
	cmpi.b	#8,1(a1); is it destruction time yet?
	bne.s	+	; if not, branch
	move.w	#-1,(a1); destroy ring
	move.w	#0,-2(a2)	; clear ring entry
	subq.w	#1,(Ring_consumption_table).w	; subtract count
+	dbf	d1,-	; repeat for all rings in table
+
	; update ring start and end addresses
	movea.w	(Ring_start_addr).w,a1
	move.w	(Camera_X_pos).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
-
	lea	6(a1),a1
+
	cmp.w	2(a1),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#6,a1
+
	cmp.w	-4(a1),d4
	bls.s	-
	move.w	a1,(Ring_start_addr).w	; update start address
	
	movea.w	(Ring_end_addr).w,a2
	addi.w	#320+16,d4
	bra.s	+
-
	lea	6(a2),a2
+
	cmp.w	2(a2),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#6,a2
+
	cmp.w	-4(a2),d4
	bls.s	-
	move.w	a2,(Ring_end_addr).w	; update end address
	tst.w	(Two_player_mode).w	; are we in 2P mode?
	bne.s	+	; if we are, update P2 addresses
	move.w	a1,(Ring_start_addr_P2).w	; otherwise, copy over P1 addresses
	move.w	a2,(Ring_end_addr_P2).w
	rts
+
	; update ring start and end addresses for P2
	movea.w	(Ring_start_addr_P2).w,a1
	move.w	(Camera_X_pos_P2).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
-
	lea	6(a1),a1
+
	cmp.w	2(a1),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#6,a1
+
	cmp.w	-4(a1),d4
	bls.s	-
	move.w	a1,(Ring_start_addr_P2).w	; update start address
	
	movea.w	(Ring_end_addr_P2).w,a2
	addi.w	#320+16,d4
	bra.s	+
-
	lea	6(a2),a2
+
	cmp.w	2(a2),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#6,a2
+
	cmp.w	-4(a2),d4
	bls.s	-
	move.w	a2,(Ring_end_addr_P2).w		; update end address
	rts

; ---------------------------------------------------------------------------
; Subroutine to handle ring collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_170BA:
Touch_Rings:
	movea.w	(Ring_start_addr).w,a1
	movea.w	(Ring_end_addr).w,a2
	cmpa.w	#MainCharacter,a0
	beq.s	+
	movea.w	(Ring_start_addr_P2).w,a1
	movea.w	(Ring_end_addr_P2).w,a2
+
	cmpa.l	a1,a2	; are there no rings in this area?
	beq.w	Touch_Rings_Done	; if so, return
	cmpi.w	#$5A,invulnerable_time(a0)
	bhs.w	Touch_Rings_Done
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	subi_.w	#8,d2	; assume X radius to be 8
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3	; subtract (Y radius - 3) from Y pos
	cmpi.b	#$4D,mapping_frame(a0)
	bne.s	+	; if you're not ducking, branch
	addi.w	#$C,d3
	moveq	#$A,d5
+
	move.w	#6,d1	; set ring radius
	move.w	#12,d6	; set ring diameter
	move.w	#16,d4	; set Sonic's X diameter
	add.w	d5,d5	; set Y diameter
; loc_17112:
Touch_Rings_Loop:
	tst.w	(a1)		; has this ring already been collided with?
	bne.w	Touch_NextRing	; if it has, branch
	move.w	2(a1),d0	; get ring X pos
	sub.w	d1,d0		; get ring left edge X pos
	sub.w	d2,d0		; subtract Sonic's left edge X pos
	bcc.s	+		; if Sonic's to the left of the ring, branch
	add.w	d6,d0		; add ring diameter
	bcs.s	++		; if Sonic's colliding, branch
	bra.w	Touch_NextRing	; otherwise, test next ring
+
	cmp.w	d4,d0		; has Sonic crossed the ring?
	bhi.w	Touch_NextRing	; if he has, branch
+
	move.w	4(a1),d0	; get ring Y pos
	sub.w	d1,d0		; get ring top edge pos
	sub.w	d3,d0		; subtract Sonic's top edge pos
	bcc.s	+		; if Sonic's above the ring, branch
	add.w	d6,d0		; add ring diameter
	bcs.s	++		; if Sonic's colliding, branch
	bra.w	Touch_NextRing	; otherwise, test next ring
+
	cmp.w	d5,d0		; has Sonic crossed the ring?
	bhi.w	Touch_NextRing	; if he has, branch
+
	move.w	#$604,(a1)	; set frame and destruction timer
	bsr.s	Touch_ConsumeRing
	lea	(Ring_consumption_table+2).w,a3

-	tst.w	(a3)+		; is this slot free?
	bne.s	-		; if not, repeat until you find one
	move.w	a1,-(a3)	; set ring address
	addq.w	#1,(Ring_consumption_table).w	; increase count
; loc_1715C:
Touch_NextRing:
	lea	6(a1),a1
	cmpa.l	a1,a2		; are we at the last ring for this area?
	bne.w	Touch_Rings_Loop	; if not, branch
; return_17166:
Touch_Rings_Done:
	rts
; ===========================================================================
; loc_17168:
Touch_ConsumeRing:
	subq.w	#1,(Perfect_rings_left).w
	cmpa.w	#MainCharacter,a0	; who collected the ring?
	beq.w	CollectRing_Sonic	; if it was Sonic, branch here
	bra.w	CollectRing_Tails	; if it was Tails, branch here

; ---------------------------------------------------------------------------
; Subroutine to draw on-screen rings
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_17178:
BuildRings:
	movea.w	(Ring_start_addr).w,a0
	movea.w	(Ring_end_addr).w,a4
	cmpa.l	a0,a4	; are there any rings on-screen?
	bne.s	+	; if there are, branch
	rts		; otherwise, return
+
	lea	(Camera_X_pos).w,a3
; loc_1718A:
BuildRings_Loop:
	tst.w	(a0)		; has this ring been consumed?
	bmi.w	BuildRings_NextRing	; if it has, branch
	move.w	2(a0),d3	; get ring X pos
	sub.w	(a3),d3		; subtract camera X pos
	addi.w	#128,d3		; screen top is 128x128 not 0x0
	move.w	4(a0),d2	; get ring Y pos
	sub.w	4(a3),d2	; subtract camera Y pos
	andi.w	#$7FF,d2
	addi_.w	#8,d2
	bmi.s	BuildRings_NextRing	; dunno how this check is supposed to work
	cmpi.w	#240,d2
	bge.s	BuildRings_NextRing	; if the ring is not on-screen, branch
	addi.w	#128-8,d2
	lea	(MapUnc_Rings).l,a1
	moveq	#0,d1
	move.b	1(a0),d1	; get ring frame
	bne.s	+		; if this ring is using a specific frame, branch
	move.b	(Rings_anim_frame).w,d1	; use global frame
+
	add.w	d1,d1
	adda.w	(a1,d1.w),a1	; get frame data address
	move.b	(a1)+,d0	; get Y offset
	ext.w	d0
	add.w	d2,d0		; add Y offset to Y pos
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0	; get art tile
	addi.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),d0	; add base art tile
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1		; skip 2P art tile
	move.w	(a1)+,d0	; get X offset
	add.w	d3,d0		; add base X pos
	move.w	d0,(a2)+	; set X pos
; loc_171EC:
BuildRings_NextRing:
	lea	6(a0),a0
	cmpa.l	a0,a4
	bne.w	BuildRings_Loop
	rts

; ---------------------------------------------------------------------------
; Subroutine to draw on-screen rings for player 1 in a 2P versus game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_171F8:
BuildRings_P1:
	lea	(Camera_X_pos).w,a3
	move.w	#128-8,d6
	movea.w	(Ring_start_addr).w,a0
	movea.w	(Ring_end_addr).w,a4
	cmpa.l	a0,a4	; are there rings on-screen?
	bne.s	BuildRings_2P_Loop	; if there are, draw them
	rts	; otherwise, return

; ---------------------------------------------------------------------------
; Subroutine to draw on-screen rings for player 2 in a 2P versus game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1720E:
BuildRings_P2:
	lea	(Camera_X_pos_P2).w,a3
	move.w	#224+128-8,d6
	movea.w	(Ring_start_addr_P2).w,a0
	movea.w	(Ring_end_addr_P2).w,a4
	cmpa.l	a0,a4	; are there rings on-screen?
	bne.s	BuildRings_2P_Loop	; if there are, draw them
	rts	; otherwise, return
; ===========================================================================
; loc_17224:
BuildRings_2P_Loop:
	tst.w	(a0)		; has this ring been consumed?
	bmi.w	BuildRings_2P_NextRing	; if it has, branch
	move.w	2(a0),d3	; get ring X pos
	sub.w	(a3),d3		; subtract camera X pos
	addi.w	#128,d3
	move.w	4(a0),d2	; get ring Y pos
	sub.w	4(a3),d2	; subtract camera Y pos
	andi.w	#$7FF,d2
	addi.w	#128+8,d2
	bmi.s	BuildRings_2P_NextRing
	cmpi.w	#240+128,d2
	bge.s	BuildRings_2P_NextRing
	add.w	d6,d2		; add base Y pos
	lea	(MapUnc_Rings).l,a1
	moveq	#0,d1
	move.b	1(a0),d1	; use ring-specific frame
	bne.s	+		; if there is one
	move.b	(Rings_anim_frame).w,d1	; otherwise use global frame
+
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P_3(pc,d4.w),(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	addq.w	#2,a1
	move.w	(a1)+,d0
	addi.w	#make_art_tile_2p(ArtTile_ArtNem_Ring,1,0),d0
	move.w	d0,(a2)+	; set art tile and flags
	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a2)+	; set X pos

BuildRings_2P_NextRing:
	lea	6(a0),a0	; load next ring
	cmpa.l	a0,a4		; are there any rings left?
	bne.w	BuildRings_2P_Loop	; if there are, loop
	rts
; ===========================================================================
; cells are double the height in 2P mode, so halve the number of rows

; byte_17294:
SpriteSizes_2P_3:
	dc.b   0,0	; 1
	dc.b   1,1	; 3
	dc.b   4,4	; 5
	dc.b   5,5	; 7
	dc.b   8,8	; 9
	dc.b   9,9	; 11
	dc.b  $C,$C	; 13
	dc.b  $D,$D	; 15

; ---------------------------------------------------------------------------
; Subroutine to perform initial rings manager setup
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_172A4:
RingsManager_Setup:
	clearRAM Ring_Positions,Ring_Positions_End
	; d0 = 0
	lea	(Ring_consumption_table).w,a1

	move.w	#bytesToLcnt(Ring_consumption_table_End-Ring_consumption_table-$40),d1	; coding error, that '-$40' shouldn't be there
-	move.l	d0,(a1)+	; only half of Ring_consumption_table is cleared
	dbf	d1,-

	moveq	#0,d5
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#6,d0
	lea	(Off_Rings).l,a1
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1
	lea	(Ring_Positions+6).w,a2	; first ring is left blank
; loc_172E0:
RingsMgr_NextRowOrCol:
	move.w	(a1)+,d2	; is this the last ring?
	bmi.s	RingsMgr_SortRings	; if it is, sort the rings
	move.w	(a1)+,d3	; is this a column of rings?
	bmi.s	RingsMgr_RingCol	; if it is, branch
	move.w	d3,d0
	rol.w	#4,d0
	andi.w	#7,d0		; store number of rings
	andi.w	#$FFF,d3	; store Y pos
; loc_172F4:
RingsMgr_NextRingInRow:
	move.w	#0,(a2)+	; set initial status
	move.w	d2,(a2)+	; set X pos
	move.w	d3,(a2)+	; set Y pos
	addi.w	#$18,d2		; increment X pos
	addq.w	#1,d5		; increment perfect counter
	dbf	d0,RingsMgr_NextRingInRow
	bra.s	RingsMgr_NextRowOrCol
; ===========================================================================
; loc_17308:
RingsMgr_RingCol:
	move.w	d3,d0
	rol.w	#4,d0
	andi.w	#7,d0		; store number of rings
	andi.w	#$FFF,d3	; store Y pos
; loc_17314:
RingsMgr_NextRingInCol:
	move.w	#0,(a2)+	; set initial status
	move.w	d2,(a2)+	; set X pos
	move.w	d3,(a2)+	; set Y pos
	addi.w	#$18,d3		; increment Y pos
	addq.w	#1,d5		; increment perfect counter
	dbf	d0,RingsMgr_NextRingInCol
	bra.s	RingsMgr_NextRowOrCol
; ===========================================================================
; loc_17328:
RingsMgr_SortRings:
	move.w	d5,(Perfect_rings_left).w
	move.w	#0,(Perfect_rings_flag).w	; no idea what this is
	moveq	#-1,d0
	move.l	d0,(a2)+	; set X pos of last ring to -1
	lea	(Ring_Positions+2).w,a1	; X pos of first ring

	move.w	#$FE,d3		; sort 255 rings
-	move.w	d3,d4
	lea	6(a1),a2	; load next ring for comparison
	move.w	(a1),d0		; get X pos of current ring

-	tst.w	(a2)		; is the next ring blank?
	beq.s	+		; if it is, branch
	cmp.w	(a2),d0		; is the X pos of current ring <= X pos of next ring?
	bls.s	+		; if so, branch
	move.l	(a1),d1		; otherwise, swap the rings
	move.l	(a2),d0
	move.l	d0,(a1)
	move.l	d1,(a2)
	swap	d0
+
	lea	6(a2),a2	; load next comparison ring
	dbf	d4,-		; repeat

	lea	6(a1),a1	; load next ring
	dbf	d3,--		; repeat

	rts
; ===========================================================================

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------

; off_1736A:
MapUnc_Rings:	BINCLUDE "mappings/sprite/Rings.bin"

    if ~~removeJmpTos
	align 4
    endif

; ----------------------------------------------------------------------------
; Object D2 - Flashing blocks that appear and disappear in a rectangular shape that you can walk across, from CNZ
; ----------------------------------------------------------------------------
; Sprite_2B528:
ObjD2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD2_Index(pc,d0.w),d1
	jmp	ObjD2_Index(pc,d1.w)
; ===========================================================================
; off_2B536:
ObjD2_Index:	offsetTable
		offsetTableEntry.w ObjD2_Init	; 0
		offsetTableEntry.w ObjD2_Main	; 2
; ===========================================================================
; loc_2B53A:
ObjD2_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD2_MapUnc_2B694,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZSnake,2,0),art_tile(a0)
	jsrto	JmpTo51_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#8,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#4,d0
	move.w	d0,objoff_38(a0)
	bsr.w	loc_2B60C
; loc_2B57E:
ObjD2_Main:
	tst.w	objoff_38(a0)
	beq.s	+
	subq.w	#1,objoff_38(a0)
	jmpto	JmpTo6_MarkObjGone3
; ===========================================================================
+
	subq.w	#1,objoff_3A(a0)
	bpl.s	loc_2B5EC
	move.w	#$F,objoff_3A(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#$F,mapping_frame(a0)
	bne.s	loc_2B5EA
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#4,d0
	move.w	d0,objoff_38(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	loc_2B5E2
	bclr	#p1_standing_bit,status(a0)
	beq.s	+
	bclr	#status.player.on_object,(MainCharacter+status).w
	bset	#status.player.in_air,(MainCharacter+status).w
+
	bclr	#p2_standing_bit,status(a0)
	beq.s	loc_2B5E2
	bclr	#status.player.on_object,(Sidekick+status).w
	bset	#status.player.in_air,(Sidekick+status).w

loc_2B5E2:
	move.w	objoff_30(a0),x_pos(a0)
	bra.s	loc_2B60C
; ===========================================================================

loc_2B5EA:
	bsr.s	loc_2B60C

loc_2B5EC:
	move.w	objoff_34(a0),d1
	addi.w	#$B,d1
	move.w	objoff_36(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo24_SolidObject
	move.w	objoff_30(a0),d0
	jmpto	JmpTo9_MarkObjGone2
; ===========================================================================

loc_2B60C:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	add.w	d0,d0
	lea	byte_2B654(pc,d0.w),a1
	move.b	(a1)+,d0
	ext.w	d0
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	d0
+
	add.w	objoff_30(a0),d0
	move.w	d0,x_pos(a0)
	move.b	(a1)+,d0
	ext.w	d0
	add.w	objoff_32(a0),d0
	move.w	d0,y_pos(a0)
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	move.b	(a1)+,d1
	move.b	(a1)+,d2
	move.w	d1,objoff_34(a0)
	move.b	d1,width_pixels(a0)
	move.w	d2,objoff_36(a0)
	rts
; ===========================================================================
byte_2B654:
	dc.b -$28, $18,   8,   8 ; $00
	dc.b -$28, $10,   8 ,$10 ; $01
	dc.b -$28,   8,   8, $18 ; $02
	dc.b -$28,   0,   8, $20 ; $03
	dc.b -$20,   0, $10, $20 ; $04
	dc.b -$18,-$08, $18, $18 ; $05
	dc.b -$10,-$10, $20, $10 ; $06
	dc.b -$08,-$18, $28,   8 ; $07
	dc.b    8,-$18, $28,   8 ; $08
	dc.b  $10,-$10, $20, $10 ; $09
	dc.b  $18,-$08, $18, $18 ; $0A
	dc.b  $20,   0, $10, $20 ; $0B
	dc.b  $28,   0,   8, $20 ; $0C
	dc.b  $28,   8,   8, $18 ; $0D
	dc.b  $28, $10,   8, $10 ; $0E
	dc.b  $28, $18,   8,   8 ; $0F
	even

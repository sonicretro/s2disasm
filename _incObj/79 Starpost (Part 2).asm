; loc_1F4C4:
Obj79_MakeSpecialStars:
	moveq	#4-1,d1 ; execute the loop 4 times (1 for each star)
	moveq	#0,d2

-	bsr.w	AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	id(a0),id(a1) ; load obj79
	move.l	#Obj79_MapUnc_1F4A0,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Checkpoint,0,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#8,routine(a1) ; => Obj79_Star
	move.w	x_pos(a0),d0
	move.w	d0,x_pos(a1)
	move.w	d0,objoff_30(a1)
	move.w	y_pos(a0),d0
	subi.w	#$30,d0
	move.w	d0,y_pos(a1)
	move.w	d0,objoff_32(a1)
	move.b	priority(a0),priority(a1)
	move.b	#8,width_pixels(a1)
	move.b	#1,mapping_frame(a1)
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.w	d2,objoff_34(a1) ; set the angle
	addi.w	#$40,d2 ; increase the angle for next time
	dbf	d1,- ; loop
+
	rts
; ===========================================================================
; loc_1F536:
Obj79_Star:
	move.b	collision_property(a0),d0
	beq.w	loc_1F554
	andi.b	#1,d0
	beq.s	+
	move.b	#1,(f_bigring).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
+
	clr.b	collision_property(a0)

loc_1F554:
	addi.w	#$A,objoff_34(a0)
	move.w	objoff_34(a0),d0
	andi.w	#$FF,d0
	jsr	(CalcSine).l
	asr.w	#5,d0
	asr.w	#3,d1
	move.w	d1,d3
	move.w	objoff_34(a0),d2
	andi.w	#$3E0,d2
	lsr.w	#5,d2
	moveq	#2,d5
	moveq	#0,d4
	cmpi.w	#$10,d2
	ble.s	+
	neg.w	d1
+
	andi.w	#$F,d2
	cmpi.w	#8,d2
	ble.s	loc_1F594
	neg.w	d2
	andi.w	#7,d2

loc_1F594:
	lsr.w	#1,d2
	beq.s	+
	add.w	d1,d4
+
	asl.w	#1,d1
	dbf	d5,loc_1F594

	asr.w	#4,d4
	add.w	d4,d0
	addq.w	#1,objoff_36(a0)
	move.w	objoff_36(a0),d1
	cmpi.w	#$80,d1
	beq.s	loc_1F5BE
	bgt.s	loc_1F5C4

loc_1F5B4:
	muls.w	d1,d0
	muls.w	d1,d3
	asr.w	#7,d0
	asr.w	#7,d3
	bra.s	loc_1F5D6
; ===========================================================================

loc_1F5BE:
	move.b	#$D8,collision_flags(a0)

loc_1F5C4:
	cmpi.w	#$180,d1
	ble.s	loc_1F5D6
	neg.w	d1
	addi.w	#$200,d1
	bmi.w	JmpTo10_DeleteObject
	bra.s	loc_1F5B4
; ===========================================================================

loc_1F5D6:
	move.w	objoff_30(a0),d2
	add.w	d3,d2
	move.w	d2,x_pos(a0)
	move.w	objoff_32(a0),d2
	add.w	d0,d2
	move.w	d2,y_pos(a0)
	addq.b	#1,anim_frame(a0)
	move.b	anim_frame(a0),d0
	andi.w	#6,d0
	lsr.w	#1,d0
	cmpi.b	#3,d0
	bne.s	+
	moveq	#1,d0
+
	move.b	d0,mapping_frame(a0)
	jmpto	JmpTo_MarkObjGone
; ===========================================================================

JmpTo10_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

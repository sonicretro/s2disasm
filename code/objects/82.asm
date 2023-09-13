; ===========================================================================
; ----------------------------------------------------------------------------
; Object 82 - Platform that is usually swinging, from ARZ
; ----------------------------------------------------------------------------
; Sprite_2A290:
Obj82:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj82_Index(pc,d0.w),d1
	jmp	Obj82_Index(pc,d1.w)
; ===========================================================================
; off_2A29E:
Obj82_Index:	offsetTable
		offsetTableEntry.w Obj82_Init	; 0
		offsetTableEntry.w Obj82_Main	; 2
; ===========================================================================
; byte_2A2A2:
Obj82_Properties:
	;    width_pixels
	;        y_radius
	dc.b $20,  8	; 0
	dc.b $1C,$30	; 2
	; Unused and broken; these don't have an associated frame, so using them crashes the game
	dc.b $10,$10	; 4
	dc.b $10,$10	; 6
; ===========================================================================
; loc_2A2AA:
Obj82_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj82_MapUnc_2A476,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo46_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	lea	Obj82_Properties(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2),y_radius(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_30(a0)
	move.b	subtype(a0),d0
	andi.b	#$F,d0
	beq.s	+
	cmpi.b	#7,d0
	beq.s	+
	move.b	#1,objoff_38(a0)
+
	andi.b	#$F,subtype(a0)
; loc_2A312:
Obj82_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.w	Obj82_Types(pc,d0.w),d1
	jsr	Obj82_Types(pc,d1.w)
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	+

	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo23_SolidObject
	swap	d6
	move.b	d6,objoff_3F(a0)
	bsr.w	loc_2A432
+
	move.w	objoff_34(a0),d0
	jmpto	MarkObjGone2, JmpTo7_MarkObjGone2
; ===========================================================================
; off_2A358:
Obj82_Types:	offsetTable
		offsetTableEntry.w return_2A368	; 0
		offsetTableEntry.w loc_2A36A	; 1
		offsetTableEntry.w loc_2A392	; 2
		offsetTableEntry.w loc_2A36A	; 3
		offsetTableEntry.w loc_2A3B6	; 4
		offsetTableEntry.w loc_2A3D8	; 5
		offsetTableEntry.w loc_2A392	; 6
		offsetTableEntry.w loc_2A3EC	; 7
; ===========================================================================

return_2A368:
	rts
; ===========================================================================

loc_2A36A:
	tst.w	objoff_36(a0)
	bne.s	loc_2A382
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_2A380
	move.w	#$1E,objoff_36(a0)

return_2A380:
	rts
; ===========================================================================

loc_2A382:
	subq.w	#1,objoff_36(a0)
	bne.s	return_2A380
	addq.b	#1,subtype(a0)
	clr.b	objoff_38(a0)
	rts
; ===========================================================================

loc_2A392:
	jsrto	ObjectMove, JmpTo16_ObjectMove
	addi_.w	#8,y_vel(a0)
	jsrto	ObjCheckFloorDist, JmpTo2_ObjCheckFloorDist
	tst.w	d1
	bpl.w	return_2A3B4
	addq.w	#1,d1
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	clr.b	subtype(a0)

return_2A3B4:
	rts
; ===========================================================================

loc_2A3B6:
	jsrto	ObjectMove, JmpTo16_ObjectMove
	subi_.w	#8,y_vel(a0)
	jsrto	ObjCheckCeilingDist, JmpTo_ObjCheckCeilingDist
	tst.w	d1
	bpl.w	return_2A3D6
	sub.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	clr.b	subtype(a0)

return_2A3D6:
	rts
; ===========================================================================

loc_2A3D8:
	move.b	objoff_3F(a0),d0
	andi.b	#3,d0
	beq.s	return_2A3EA
	addq.b	#1,subtype(a0)
	clr.b	objoff_38(a0)

return_2A3EA:
	rts
; ===========================================================================

loc_2A3EC:
	move.w	(Water_Level_1).w,d0
	sub.w	y_pos(a0),d0
	beq.s	return_2A430
	bcc.s	loc_2A414
	cmpi.w	#-2,d0
	bge.s	loc_2A400
	moveq	#-2,d0

loc_2A400:
	add.w	d0,y_pos(a0)
	jsrto	ObjCheckCeilingDist, JmpTo_ObjCheckCeilingDist
	tst.w	d1
	bpl.w	return_2A412
	sub.w	d1,y_pos(a0)

return_2A412:
	rts
; ===========================================================================

loc_2A414:
	cmpi.w	#2,d0
	ble.s	loc_2A41C
	moveq	#2,d0

loc_2A41C:
	add.w	d0,y_pos(a0)
	jsrto	ObjCheckFloorDist, JmpTo2_ObjCheckFloorDist
	tst.w	d1
	bpl.w	return_2A430
	addq.w	#1,d1
	add.w	d1,y_pos(a0)

return_2A430:
	rts
; ===========================================================================

loc_2A432:
	tst.b	objoff_38(a0)
	beq.s	return_2A474
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	loc_2A44E
	tst.b	objoff_3E(a0)
	beq.s	return_2A474
	subq.b	#4,objoff_3E(a0)
	bra.s	loc_2A45A
; ===========================================================================

loc_2A44E:
	cmpi.b	#$40,objoff_3E(a0)
	beq.s	return_2A474
	addq.b	#4,objoff_3E(a0)

loc_2A45A:
	move.b	objoff_3E(a0),d0
	jsr	(CalcSine).l
	move.w	#$400,d1
	muls.w	d1,d0
	swap	d0
	add.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)

return_2A474:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj82_MapUnc_2A476:	include "mappings/sprite/obj82.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_ObjCheckFloorDist ; JmpTo
	jmp	(ObjCheckFloorDist).l
JmpTo46_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_ObjCheckCeilingDist ; JmpTo
	jmp	(ObjCheckCeilingDist).l
JmpTo23_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo7_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l
; loc_2A4F6:
JmpTo16_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif

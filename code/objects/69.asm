; ===========================================================================
; ----------------------------------------------------------------------------
; Object 69 - Nut from MTZ
; ----------------------------------------------------------------------------
; Sprite_27884:
Obj69:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj69_Index(pc,d0.w),d1
	jmp	Obj69_Index(pc,d1.w)
; ===========================================================================
; off_27892:
Obj69_Index:	offsetTable
		offsetTableEntry.w Obj69_Init	; 0
		offsetTableEntry.w Obj69_Main	; 2
		offsetTableEntry.w loc_279FC	; 4
		offsetTableEntry.w loc_278F4	; 6
; ===========================================================================
; loc_2789A:
Obj69_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj69_MapUnc_27A26,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzAsstBlocks,1,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo32_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$B,y_radius(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	subtype(a0),d0
	andi.w	#$7F,d0
	lsl.w	#3,d0
	move.w	d0,objoff_36(a0)
; loc_278DC:
Obj69_Main:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	objoff_38(a0),a4
	moveq	#p1_standing_bit,d6
	bsr.s	Obj69_Action
	lea	(Sidekick).w,a1 ; a1=character
	lea	objoff_3C(a0),a4
	moveq	#p2_standing_bit,d6
	bsr.s	Obj69_Action

loc_278F4:

	andi.w	#$7FF,y_pos(a0)
	move.w	#$2B,d1
	move.w	#$C,d2
	move.w	#$D,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo12_SolidObject
	jmpto	MarkObjGone, JmpTo21_MarkObjGone
; ===========================================================================
; loc_27912:
Obj69_Action:
	btst	d6,status(a0)
	bne.s	+
	clr.b	(a4)
+
	moveq	#0,d0
	move.b	(a4),d0
	move.w	Obj69_Modes(pc,d0.w),d0
	jmp	Obj69_Modes(pc,d0.w)
; ===========================================================================
; off_27926:
Obj69_Modes:	offsetTable
		offsetTableEntry.w loc_2792C	; 0
		offsetTableEntry.w loc_2794C	; 2
		offsetTableEntry.w loc_2796E	; 4
; ===========================================================================

loc_2792C:
	btst	d6,status(a0)
	bne.s	+
	rts
; ===========================================================================
+
	addq.b	#2,(a4)
	move.b	#0,1(a4)
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcc.s	loc_2794C
	move.b	#1,1(a4)

loc_2794C:

	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	tst.b	1(a4)
	beq.s	+
	addi.w	#$F,d0
+
	cmpi.w	#$10,d0
	bhs.s	+	; rts
	move.w	x_pos(a0),x_pos(a1)
	addq.b	#2,(a4)
+
	rts
; ===========================================================================

loc_2796E:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_279D4
	add.w	d0,objoff_34(a0)
	move.w	x_pos(a0),x_pos(a1)
	move.w	objoff_34(a0),d0
	asr.w	#3,d0
	move.w	d0,d1
	asr.w	#1,d0
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	neg.w	d1
	add.w	objoff_32(a0),d1
	move.w	d1,y_pos(a0)
	sub.w	objoff_32(a0),d1
	move.w	objoff_36(a0),d0
	cmp.w	d0,d1
	blt.s	return_279D2
	move.w	d0,d1
	add.w	objoff_32(a0),d1
	move.w	d1,y_pos(a0)
	lsl.w	#3,d0
	neg.w	d0
	move.w	d0,objoff_34(a0)
	move.b	#0,mapping_frame(a0)
	tst.b	subtype(a0)
	bmi.s	loc_279CC
	clr.b	(a4)
	rts
; ===========================================================================

loc_279CC:
	move.b	#4,routine(a0)

return_279D2:
	rts
; ===========================================================================

loc_279D4:
	add.w	d0,objoff_34(a0)
	move.w	x_pos(a0),x_pos(a1)
	move.w	objoff_34(a0),d0
	asr.w	#3,d0
	move.w	d0,d1
	asr.w	#1,d0
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	neg.w	d1
	add.w	objoff_32(a0),d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_279FC:
	jsrto	ObjectMove, JmpTo13_ObjectMove
	addi.w	#$38,y_vel(a0)
	jsrto	ObjCheckFloorDist, JmpTo_ObjCheckFloorDist
	tst.w	d1
	bpl.w	+
	add.w	d1,y_pos(a0)
	andi.w	#$7FF,y_pos(a0)
	clr.w	y_vel(a0)
	addq.b	#2,routine(a0)
+
	bra.w	loc_278F4
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj69_MapUnc_27A26:	include "mappings/sprite/obj69.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo21_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo_ObjCheckFloorDist ; JmpTo
	jmp	(ObjCheckFloorDist).l
JmpTo32_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo12_SolidObject ; JmpTo
	jmp	(SolidObject).l
; loc_27AA8:
JmpTo13_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif

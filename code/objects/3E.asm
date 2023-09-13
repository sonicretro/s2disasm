; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3E - Egg prison
; ----------------------------------------------------------------------------
; Sprite_3F1E4:
Obj3E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3E_Index(pc,d0.w),d1
	jmp	Obj3E_Index(pc,d1.w)
; ===========================================================================
; off_3F1F2:
Obj3E_Index:	offsetTable
		offsetTableEntry.w loc_3F212	;  0
		offsetTableEntry.w loc_3F278	;  2
		offsetTableEntry.w loc_3F354	;  4
		offsetTableEntry.w loc_3F38E	;  6
		offsetTableEntry.w loc_3F3A8	;  8
		offsetTableEntry.w loc_3F406	; $A
; ----------------------------------------------------------------------------
; byte_3F1FE:
Obj3E_ObjLoadData:
	dc.b   0,  2,$20,  4,  0
	dc.b $28,  4,$10,  5,  4	; 5
	dc.b $18,  6,  8,  3,  5	; 10
	dc.b   0,  8,$20,  4,  0	; 15
	even
; ===========================================================================

loc_3F212:
	movea.l	a0,a1
	lea	objoff_38(a0),a3
	lea	Obj3E_ObjLoadData(pc),a2
	moveq	#3,d1
	bra.s	loc_3F228
; ===========================================================================

loc_3F220:
	jsrto	AllocateObject, JmpTo20_AllocateObject
	bne.s	loc_3F272
	move.w	a1,(a3)+

loc_3F228:
	_move.b	id(a0),id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	y_pos(a0),objoff_30(a1)
	move.l	#Obj3E_MapUnc_3F436,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Capsule,1,0),art_tile(a1)
	move.b	#$84,render_flags(a1)
	moveq	#0,d0
	move.b	(a2)+,d0
	sub.w	d0,y_pos(a1)
	move.w	y_pos(a1),objoff_30(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,width_pixels(a1)
	move.b	(a2)+,priority(a1)
	move.b	(a2)+,mapping_frame(a1)

loc_3F272:
	dbf	d1,loc_3F220
	rts
; ===========================================================================

loc_3F278:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3F2AE(pc,d0.w),d1
	jsr	off_3F2AE(pc,d1.w)
	move.w	#$2B,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	x_pos(a0),d4
	jsr	(SolidObject).l
	lea	(Ani_obj3E).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
off_3F2AE:	offsetTable
		offsetTableEntry.w loc_3F2B4	; 0
		offsetTableEntry.w loc_3F2FC	; 2
		offsetTableEntry.w return_3F352	; 4
; ===========================================================================

loc_3F2B4:
	movea.w	objoff_38(a0),a1 ; a1=object
	tst.w	objoff_32(a1)
	beq.s	++	; rts
	movea.w	objoff_3A(a0),a2 ; a2=object
	jsr	(AllocateObject).l
	bne.s	+
	_move.b	#ObjID_Explosion,id(a1) ; load obj
	addq.b	#2,routine(a1)
	move.w	x_pos(a2),x_pos(a1)
	move.w	y_pos(a2),y_pos(a1)
+
	move.w	#-$400,y_vel(a2)
	move.w	#$800,x_vel(a2)
	addq.b	#2,routine_secondary(a2)
	move.w	#$1D,objoff_34(a0)
	addq.b	#2,routine_secondary(a0)
+
	rts
; ===========================================================================

loc_3F2FC:
	subq.w	#1,objoff_34(a0)
	bpl.s	return_3F352
	move.b	#1,anim(a0)
	moveq	#7,d6
	move.w	#$9A,d5
	moveq	#-$1C,d4

-	jsr	(AllocateObject).l
	bne.s	+
	_move.b	#ObjID_Animal,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	add.w	d4,x_pos(a1)
	move.b	#1,objoff_38(a1)
	addq.w	#7,d4
	move.w	d5,objoff_36(a1)
	subq.w	#8,d5
	dbf	d6,-
+
	movea.w	objoff_3C(a0),a2 ; a2=object
	move.w	#$B4,anim_frame_duration(a2)
	addq.b	#2,routine_secondary(a2)
	addq.b	#2,routine_secondary(a0)

return_3F352:
	rts
; ===========================================================================

loc_3F354:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsr	(SolidObject).l
	move.w	objoff_30(a0),y_pos(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+
	addq.w	#8,y_pos(a0)
	clr.b	(Update_HUD_timer).w
	move.w	#1,objoff_32(a0)
+
	jmp	(MarkObjGone).l
; ===========================================================================

loc_3F38E:
	tst.b	routine_secondary(a0)
	beq.s	+
	tst.b	render_flags(a0)
	bpl.w	JmpTo66_DeleteObject
	jsr	(ObjectMoveAndFall).l
+
	jmp	(MarkObjGone).l

    if removeJmpTos
JmpTo66_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================

loc_3F3A8:
	tst.b	routine_secondary(a0)
	beq.s	return_3F404
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	loc_3F3F4
	jsr	(AllocateObject).l
	bne.s	loc_3F3F4
	_move.b	#ObjID_Animal,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	andi.w	#$1F,d0
	subq.w	#6,d0
	tst.w	d1
	bpl.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a1)
	move.b	#1,objoff_38(a1)
	move.w	#$C,objoff_36(a1)

loc_3F3F4:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	return_3F404
	addq.b	#2,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)

return_3F404:
	rts
; ===========================================================================

loc_3F406:
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d0
	moveq	#ObjID_Animal,d1
	lea	(Dynamic_Object_RAM).w,a1

-	cmp.b	id(a1),d1
	beq.s	+	; rts
	lea	next_object(a1),a1 ; a1=object
	dbf	d0,-

	jsr	(Load_EndOfAct).l
	jmp	(DeleteObject).l
; ===========================================================================
+	rts
; ===========================================================================
; animation script
; off_3F428:
Ani_obj3E:	offsetTable
		offsetTableEntry.w byte_3F42C	; 0
		offsetTableEntry.w byte_3F42F	; 1
byte_3F42C:	dc.b  $F,  0,$FF
		rev02even
byte_3F42F:	dc.b   3,  0,  1,  2,  3,$FE,  1
		even
; ----------------------------------------------------------------------------
; sprite mappings
; [fixBugs] These mappings contain a bug: the second and third sprites have
; their 'total sprite pieces' value set too low by one, causing the last
; sprite piece to not be displayed.
; ----------------------------------------------------------------------------
Obj3E_MapUnc_3F436:	include "mappings/sprite/obj3E.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo66_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo20_AllocateObject ; JmpTo
	jmp	(AllocateObject).l

	align 4
    endif

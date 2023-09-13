; ===========================================================================
; ----------------------------------------------------------------------------
; Object 73 - Solid rotating ring thing from Mystic Cave Zone
; (unused, but can be seen in debug mode)
; ----------------------------------------------------------------------------
; Sprite_289D4:
Obj73:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj73_Index(pc,d0.w),d1
	jmp	Obj73_Index(pc,d1.w)
; ===========================================================================
; off_289E2:
Obj73_Index:	offsetTable
		offsetTableEntry.w Obj73_Init		; 0
		offsetTableEntry.w Obj73_Main		; 2
		offsetTableEntry.w Obj73_SubObject	; 4
; ===========================================================================
; loc_289E8:
Obj73_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj73_MapUnc_28B9C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo37_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	x_pos(a0),objoff_3A(a0)
	move.w	y_pos(a0),objoff_38(a0)
	move.b	#0,collision_flags(a0)
	bset	#7,status(a0)
	move.b	subtype(a0),d1
	andi.b	#$F0,d1
	ext.w	d1
	asl.w	#3,d1
	move.w	d1,objoff_3E(a0)
	move.b	status(a0),d0
	ror.b	#2,d0
	andi.b	#$C0,d0
	move.b	d0,angle(a0)
	lea	objoff_29(a0),a2
	move.b	subtype(a0),d1
	andi.w	#7,d1
	move.b	#0,(a2)+
	move.w	d1,d3
	lsl.w	#4,d3
	move.b	d3,objoff_3C(a0)
	subq.w	#1,d1
	bcs.s	Obj73_LoadSubObject_End
	btst	#3,subtype(a0)
	beq.s	Obj73_LoadSubObject
	subq.w	#1,d1
	bcs.s	Obj73_LoadSubObject_End
; loc_28A6E:
Obj73_LoadSubObject:
	jsrto	AllocateObject, JmpTo9_AllocateObject
	bne.s	Obj73_LoadSubObject_End
	addq.b	#1,objoff_29(a0)
    if object_size<>$40
	moveq	#0,d5 ; Clear the high word for the coming division.
    endif
	move.w	a1,d5
	subi.w	#Object_RAM,d5
    if object_size=$40
	lsr.w	#object_size_bits,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
	move.b	#4,routine(a1)
	_move.b	id(a0),id(a1) ; load obj73
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.b	collision_flags(a0),collision_flags(a1)
	move.b	status(a0),status(a1)
	subi.b	#$10,d3
	move.b	d3,objoff_3C(a1)
	dbf	d1,Obj73_LoadSubObject
; loc_28AC8:
Obj73_LoadSubObject_End:

    if object_size<>$40
	moveq	#0,d5 ; Clear the high word for the coming division.
    endif
	move.w	a0,d5
	subi.w	#Object_RAM,d5
    if object_size=$40
	lsr.w	#object_size_bits,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
; loc_28AD6:
Obj73_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	loc_28AF4
	move.w	#8,d1
	move.w	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo17_SolidObject
	bra.w	loc_28B46
; ===========================================================================

loc_28AF4:
	move.w	objoff_3E(a0),d0
	add.w	d0,angle(a0)
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	move.w	objoff_38(a0),d2
	move.w	objoff_3A(a0),d3
	lea	objoff_29(a0),a2
	moveq	#0,d6
	move.b	(a2)+,d6

loc_28B16:
	moveq	#0,d4
	move.b	(a2)+,d4
    if object_size=$40
	lsl.w	#object_size_bits,d4
    else
	mulu.w	#object_size,d4
    endif
	addi.l	#Object_RAM,d4
	movea.l	d4,a1 ; a1=object
	moveq	#0,d4
	move.b	objoff_3C(a1),d4
	move.l	d4,d5
	muls.w	d0,d4
	asr.l	#8,d4
	muls.w	d1,d5
	asr.l	#8,d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d4,y_pos(a1)
	move.w	d5,x_pos(a1)
	dbf	d6,loc_28B16
	rts
; ===========================================================================

loc_28B46:
	move.w	objoff_3A(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	DisplaySprite, JmpTo21_DisplaySprite
; ===========================================================================
+
	moveq	#0,d2
	lea	objoff_29(a0),a2

	move.b	(a2)+,d2
-	moveq	#0,d0
	move.b	(a2)+,d0
    if object_size=$40
	lsl.w	#object_size_bits,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a1	; a1=object
	jsrto	DeleteObject2, JmpTo_DeleteObject2
	dbf	d2,-
	rts
; ===========================================================================
; loc_28B7E:
Obj73_SubObject:
	move.w	#8,d1
	move.w	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	objoff_36(a0),d4
	jsrto	SolidObject, JmpTo17_SolidObject
	move.w	x_pos(a0),objoff_36(a0)
	jmpto	DisplaySprite, JmpTo21_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj73_MapUnc_28B9C:	include "mappings/sprite/obj73.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo21_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo9_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo37_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo17_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

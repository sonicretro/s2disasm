; ===========================================================================
; ----------------------------------------------------------------------------
; Object 78 - Stairs from CPZ that move down to open the way
; ----------------------------------------------------------------------------
; Sprite_291CC:
Obj78:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj78_Index(pc,d0.w),d1
	jsr	Obj78_Index(pc,d1.w)
	move.w	objoff_30(a0),d0
	jmpto	MarkObjGone2, JmpTo6_MarkObjGone2
; ===========================================================================
; off_291E2:
Obj78_Index:	offsetTable
		offsetTableEntry.w Obj78_Init	; 0
		offsetTableEntry.w Obj78_Main	; 2
		offsetTableEntry.w loc_29280	; 4
; ===========================================================================
; loc_291E8:
Obj78_Init:
	addq.b	#2,routine(a0)
	moveq	#objoff_34,d3
	moveq	#2,d4
	btst	#0,status(a0)
	beq.s	+
	moveq	#objoff_3A,d3
	moveq	#-2,d4
+
	move.w	x_pos(a0),d2
	movea.l	a0,a1
	moveq	#3,d1
	bra.s	Obj78_LoadSubObject
; ===========================================================================
; loc_29206:
Obj78_SubObjectLoop:
	jsrto	AllocateObjectAfterCurrent, JmpTo16_AllocateObjectAfterCurrent
	bne.w	Obj78_Main
	move.b	#4,routine(a1)
; loc_29214:
Obj78_LoadSubObject:
	_move.b	id(a0),id(a1) ; load obj78
	move.l	#Obj6B_MapUnc_2800E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo5_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	subtype(a0),subtype(a1)
	move.w	d2,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a0),objoff_30(a1)
	move.w	y_pos(a1),objoff_32(a1)
	addi.w	#$20,d2
	move.b	d3,objoff_2F(a1)
	move.l	a0,objoff_3C(a1)
	add.b	d4,d3
	dbf	d1,Obj78_SubObjectLoop

; loc_2926C:
Obj78_Main:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#7,d0
	add.w	d0,d0
	move.w	Obj78_Types(pc,d0.w),d1
	jsr	Obj78_Types(pc,d1.w)

loc_29280:
	movea.l	objoff_3C(a0),a2 ; a2=object
	moveq	#0,d0
	move.b	objoff_2F(a0),d0
	move.w	(a2,d0.w),d0
	add.w	objoff_32(a0),d0
	move.w	d0,y_pos(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo21_SolidObject
	swap	d6
	or.b	d6,objoff_2E(a2)
	rts
; ===========================================================================
; off_292B8:
Obj78_Types:	offsetTable
		offsetTableEntry.w loc_292C8	; 0
		offsetTableEntry.w loc_29334	; 1
		offsetTableEntry.w loc_292EC	; 2
		offsetTableEntry.w loc_29334	; 3
		offsetTableEntry.w loc_292C8	; 4
		offsetTableEntry.w loc_2935E	; 5
		offsetTableEntry.w loc_292EC	; 6
		offsetTableEntry.w loc_2935E	; 7
; ===========================================================================

loc_292C8:
	tst.w	objoff_2C(a0)
	bne.s	loc_292E0
	move.b	objoff_2E(a0),d0
	andi.b	#touch_top_mask,d0
	beq.s	return_292DE
	move.w	#$1E,objoff_2C(a0)

return_292DE:
	rts
; ===========================================================================

loc_292E0:
	subq.w	#1,objoff_2C(a0)
	bne.s	return_292DE
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_292EC:
	tst.w	objoff_2C(a0)
	bne.s	loc_29304
	move.b	objoff_2E(a0),d0
	andi.b	#touch_bottom_mask,d0
	beq.s	return_29302
	move.w	#60,objoff_2C(a0)

return_29302:
	rts
; ===========================================================================

loc_29304:
	subq.w	#1,objoff_2C(a0)
	bne.s	loc_29310
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_29310:
	lea	objoff_34(a0),a1 ; a1=object
	move.w	objoff_2C(a0),d0
	lsr.b	#2,d0
	andi.b	#1,d0
	move.w	d0,(a1)+
	eori.b	#1,d0
	move.w	d0,(a1)+
	eori.b	#1,d0
	move.w	d0,(a1)+
	eori.b	#1,d0
	move.w	d0,(a1)+
	rts
; ===========================================================================

loc_29334:
	lea	objoff_34(a0),a1 ; a1=object
	cmpi.w	#$80,(a1)
	beq.s	return_2935C
	addq.w	#1,(a1)
	moveq	#0,d1
	move.w	(a1)+,d1
	swap	d1
	lsr.l	#1,d1
	move.l	d1,d2
	lsr.l	#1,d1
	move.l	d1,d3
	add.l	d2,d3
	swap	d1
	swap	d2
	swap	d3
	move.w	d3,(a1)+
	move.w	d2,(a1)+
	move.w	d1,(a1)+

return_2935C:
	rts
; ===========================================================================

loc_2935E:
	lea	objoff_34(a0),a1 ; a1=object
	cmpi.w	#-$80,(a1)
	beq.s	return_29386
	subq.w	#1,(a1)
	moveq	#0,d1
	move.w	(a1)+,d1
	swap	d1
	asr.l	#1,d1
	move.l	d1,d2
	asr.l	#1,d1
	move.l	d1,d3
	add.l	d2,d3
	swap	d1
	swap	d2
	swap	d3
	move.w	d3,(a1)+
	move.w	d2,(a1)+
	move.w	d1,(a1)+

return_29386:
	rts
; ===========================================================================

    if ~~removeJmpTos
JmpTo16_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo5_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo21_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo6_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6A - Platform that moves when you walk off of it, from MTZ
; ----------------------------------------------------------------------------
; Sprite_27AB0:
Obj6A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6A_Index(pc,d0.w),d1
	jmp	Obj6A_Index(pc,d1.w)
; ===========================================================================
; off_27ABE:
Obj6A_Index:	offsetTable
		offsetTableEntry.w Obj6A_Init	; 0
		offsetTableEntry.w loc_27BDE	; 2
		offsetTableEntry.w loc_27C66	; 4
; ===========================================================================
; loc_27AC4:
Obj6A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj65_Obj6A_Obj6B_MapUnc_26EC8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$C,y_radius(a0)
	move.l	#byte_27CDC,objoff_2C(a0)
	move.b	#1,mapping_frame(a0)
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.w	loc_27BC4
	addq.b	#2,routine(a0)
	move.l	#Obj6A_MapUnc_27D30,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Crate,3,0),art_tile(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$20,y_radius(a0)
	move.l	#byte_27CF4,objoff_2C(a0)
	btst	#0,status(a0)
	beq.s	+
	move.l	#byte_27D12,objoff_2C(a0)
+
	move.b	#0,mapping_frame(a0)
	cmpi.b	#$18,subtype(a0)
	bne.w	loc_27BD0
	jsrto	AllocateObjectAfterCurrent, JmpTo13_AllocateObjectAfterCurrent
	bne.s	++
	bsr.s	Obj6A_InitSubObject
	addi.w	#$40,x_pos(a1)
	addi.w	#$40,y_pos(a1)
	move.b	#6,subtype(a1)
	btst	#0,status(a0)
	beq.s	+
	move.b	#$C,subtype(a1)
+
	jsrto	AllocateObjectAfterCurrent, JmpTo13_AllocateObjectAfterCurrent
	bne.s	+
	bsr.s	Obj6A_InitSubObject
	subi.w	#$40,x_pos(a1)
	addi.w	#$40,y_pos(a1)
	move.b	#$C,subtype(a1)
	btst	#0,status(a0)
	beq.s	+
	move.b	#6,subtype(a1)
+
	bra.s	loc_27BC4
; ===========================================================================
; loc_27B9E:
Obj6A_InitSubObject:
	_move.b	id(a0),id(a1) ; load obj6A
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a0),objoff_32(a1)
	move.w	y_pos(a0),objoff_30(a1)
	move.b	status(a0),status(a1)
	rts
; ===========================================================================

loc_27BC4:
	move.w	x_pos(a0),objoff_32(a0)
	move.w	y_pos(a0),objoff_30(a0)

loc_27BD0:
	jsrto	Adjust2PArtPointer, JmpTo33_Adjust2PArtPointer
	move.b	subtype(a0),objoff_38(a0)
	bra.w	loc_27CA2
; ===========================================================================

loc_27BDE:
	move.w	x_pos(a0),-(sp)
	tst.w	objoff_36(a0)
	bne.s	loc_27C2E
	move.b	objoff_3C(a0),d1
	move.b	status(a0),d0
	btst	#p1_standing_bit,d0
	bne.s	loc_27C0A
	btst	#p1_standing_bit,d1
	beq.s	loc_27C0E
	move.b	#1,objoff_36(a0)
	move.b	#0,objoff_3C(a0)
	bra.s	loc_27C3E
; ===========================================================================

loc_27C0A:
	move.b	d0,objoff_3C(a0)

loc_27C0E:
	btst	#p2_standing_bit,d0
	bne.s	loc_27C28
	btst	#p2_standing_bit,d1
	beq.s	loc_27C3E
	move.b	#1,objoff_36(a0)
	move.b	#0,objoff_3C(a0)
	bra.s	loc_27C3E
; ===========================================================================

loc_27C28:
	move.b	d0,objoff_3C(a0)
	bra.s	loc_27C3E
; ===========================================================================
loc_27C2E:
	jsr	(ObjectMove).l
	subq.w	#1,objoff_34(a0)
	bne.s	loc_27C3E
	bsr.w	loc_27CA2

loc_27C3E:
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	loc_27C5E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo13_SolidObject

loc_27C5E:
	move.w	objoff_32(a0),d0
	jmpto	MarkObjGone2, JmpTo3_MarkObjGone2
; ===========================================================================

loc_27C66:
	move.w	x_pos(a0),-(sp)
	jsr	(ObjectMove).l
	subq.w	#1,objoff_34(a0)
	bne.s	loc_27C7A
	bsr.w	loc_27CA2

loc_27C7A:
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	loc_27C9A
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo13_SolidObject

loc_27C9A:
	move.w	objoff_32(a0),d0
	jmpto	MarkObjGone2, JmpTo3_MarkObjGone2
; ===========================================================================

loc_27CA2:
	moveq	#0,d0
	move.b	objoff_38(a0),d0
	movea.l	objoff_2C(a0),a1 ; a1=object
	lea	(a1,d0.w),a1
	move.w	(a1)+,x_vel(a0)
	move.w	(a1)+,y_vel(a0)
	move.w	(a1)+,objoff_34(a0)
	move.w	#7,objoff_3A(a0)
	move.b	#0,objoff_36(a0)
	addq.b	#6,objoff_38(a0)
	cmpi.b	#$18,objoff_38(a0)
	blo.s	return_27CDA
	move.b	#0,objoff_38(a0)

return_27CDA:
	rts
; ===========================================================================
byte_27CDC:
	dc.b   0,  0,  4,  0,  0,$10,  4,  0,$FE,  0,  0,$20,  0,  0,  4,  0
	dc.b   0,$10,$FC,  0,$FE,  0,  0,$20; 16
byte_27CF4:
	dc.b   0,  0,  1,  0,  0,$40,$FF,  0,  0,  0,  0,$80,  0,  0,$FF,  0
	dc.b   0,$40,  1,  0,  0,  0,  0,$80,  1,  0,  0,  0,  0,$40; 16
byte_27D12:
	dc.b   0,  0,  1,  0,  0,$40,  1,  0,  0,  0,  0,$80,  0,  0,$FF,  0
	dc.b   0,$40,$FF,  0,  0,  0,  0,$80,$FF,  0,  0,  0,  0,$40; 16
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6A_MapUnc_27D30:	include "mappings/sprite/obj6A.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo13_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo33_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo13_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo3_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif

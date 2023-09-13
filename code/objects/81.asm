; ===========================================================================
; ----------------------------------------------------------------------------
; Object 81 - Drawbridge (MCZ)
; ----------------------------------------------------------------------------
; Sprite_2A000:
Obj81:
	btst	#6,render_flags(a0)
	bne.w	+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj81_Index(pc,d0.w),d1
	jmp	Obj81_Index(pc,d1.w)
; ===========================================================================
+
	move.w	#object_display_list_size*5,d0
	jmpto	DisplaySprite3, JmpTo2_DisplaySprite3
; ===========================================================================
; off_2A020:
Obj81_Index:	offsetTable
		offsetTableEntry.w Obj81_Init		; 0
		offsetTableEntry.w Obj81_BridgeUp	; 2
		offsetTableEntry.w loc_2A18A		; 4
; ===========================================================================
; loc_2A026:
Obj81_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj81_MapUnc_2A24E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo45_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#5,priority(a0)
	move.b	#8,width_pixels(a0)
	ori.b	#$80,status(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	subi.w	#$48,y_pos(a0)
	move.b	#-$40,angle(a0)
	moveq	#-$10,d4
	btst	#1,status(a0)
	beq.s	+
	addi.w	#$90,y_pos(a0)
	move.b	#$40,angle(a0)
	neg.w	d4
+
	move.w	#$100,d1
	btst	#0,status(a0)
	beq.s	+
	neg.w	d1
+
	move.w	d1,objoff_34(a0)
	jsrto	AllocateObjectAfterCurrent, JmpTo18_AllocateObjectAfterCurrent
	bne.s	Obj81_BridgeUp
	_move.b	id(a0),id(a1) ; load obj81
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	move.w	objoff_30(a0),d2
	move.w	objoff_32(a0),d3
	moveq	#8,d1
	move.b	d1,mainspr_childsprites(a1)
	subq.w	#1,d1
	lea	subspr_data(a1),a2

-	add.w	d4,d3
	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#1,(a2)+	; sub?_mapframe
	dbf	d1,-

	move.w	sub6_x_pos(a1),x_pos(a1)
	move.w	sub6_y_pos(a1),y_pos(a1)
	move.l	a1,objoff_3C(a0)
	move.b	#$40,mainspr_height(a1)
	bset	#4,render_flags(a1)
; loc_2A0FE:
Obj81_BridgeUp:
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	btst	#0,(a2,d0.w)
	beq.s	+
	tst.b	objoff_36(a0)
	bne.s	+
	move.b	#1,objoff_36(a0)
	move.w	#SndID_DrawbridgeMove,d0
	jsr	(PlaySound2).l
	cmpi.b	#$81,status(a0)
	bne.s	+
	move.w	objoff_30(a0),x_pos(a0)
	subi.w	#$48,x_pos(a0)
+
	tst.b	objoff_36(a0)
	beq.s	loc_2A188
	move.w	#$48,d1
	tst.b	angle(a0)
	beq.s	loc_2A154
	cmpi.b	#$80,angle(a0)
	bne.s	loc_2A180
	neg.w	d1

loc_2A154:
	move.w	objoff_32(a0),y_pos(a0)
	move.w	objoff_30(a0),x_pos(a0)
	add.w	d1,x_pos(a0)
	move.b	#$40,width_pixels(a0)
	move.b	#0,objoff_36(a0)
	move.w	#SndID_DrawbridgeDown,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)
	bra.s	loc_2A188
; ===========================================================================

loc_2A180:
	move.w	objoff_34(a0),d0
	add.w	d0,angle(a0)

loc_2A188:
	bsr.s	loc_2A1EA

loc_2A18A:
	move.w	#$13,d1
	move.w	#$40,d2
	move.w	#$41,d3
	move.b	angle(a0),d0
	beq.s	loc_2A1A8
	cmpi.b	#$40,d0
	beq.s	loc_2A1B4
	cmpi.b	#-$40,d0
	bhs.s	loc_2A1B4

loc_2A1A8:
	move.w	#$4B,d1
	move.w	#8,d2
	move.w	#9,d3

loc_2A1B4:
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo22_SolidObject
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	DisplaySprite, JmpTo26_DisplaySprite
; ---------------------------------------------------------------------------
+
	move.w	objoff_30(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	DisplaySprite, JmpTo26_DisplaySprite
; ---------------------------------------------------------------------------
+
	movea.l	objoff_3C(a0),a1 ; a1=object
	jsrto	DeleteObject2, JmpTo3_DeleteObject2
	jmpto	DeleteObject, JmpTo41_DeleteObject
; ===========================================================================

loc_2A1EA:
	tst.b	objoff_36(a0)
	beq.s	return_2A24C
	moveq	#0,d0
	moveq	#0,d1
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo9_CalcSine
	move.w	objoff_32(a0),d2
	move.w	objoff_30(a0),d3
	moveq	#0,d6
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.b	mainspr_childsprites(a1),d6
	subq.w	#1,d6
	bcs.s	return_2A24C
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	lea	subspr_data(a1),a2

-	movem.l	d4-d5,-(sp)
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,(a2)+	; sub?_x_pos
	move.w	d4,(a2)+	; sub?_y_pos
	movem.l	(sp)+,d4-d5
	add.l	d0,d4
	add.l	d1,d5
	addq.w	#next_subspr-4,a2
	dbf	d6,-

	move.w	sub6_x_pos(a1),x_pos(a1)
	move.w	sub6_y_pos(a1),y_pos(a1)

return_2A24C:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj81_MapUnc_2A24E:	include "mappings/sprite/obj81.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo26_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo41_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo3_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo18_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo45_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo9_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo22_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 75 - Brick from MCZ
; ----------------------------------------------------------------------------
; Sprite_28BC8:
Obj75:
	btst	#6,render_flags(a0)
	bne.w	+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj75_Index(pc,d0.w),d1
	jmp	Obj75_Index(pc,d1.w)
; ===========================================================================
+
	move.w	#object_display_list_size*5,d0
	jmpto	DisplaySprite3, JmpTo_DisplaySprite3
; ===========================================================================
; off_28BE8:
Obj75_Index:	offsetTable
		offsetTableEntry.w Obj75_Init	; 0
		offsetTableEntry.w Obj75_Main	; 2
		offsetTableEntry.w loc_28D6C	; 4
; ===========================================================================
; loc_28BEE:
Obj75_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj75_MapUnc_28D8A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo38_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	subtype(a0),d1
	move.b	d1,d0
	andi.w	#$F,d1
	andi.b	#$F0,d0
	ext.w	d0
	asl.w	#3,d0
	move.w	d0,objoff_34(a0)
	move.b	status(a0),d0
	ror.b	#2,d0
	andi.b	#$C0,d0
	move.b	d0,angle(a0)
	cmpi.b	#$F,d1
	bne.s	+
	addq.b	#2,routine(a0)
	move.b	#4,priority(a0)
	move.b	#2,mapping_frame(a0)
	rts
; ===========================================================================
+
	move.b	#$9A,collision_flags(a0)
	jsrto	AllocateObjectAfterCurrent, JmpTo15_AllocateObjectAfterCurrent
	bne.s	Obj75_Main
	_move.b	id(a0),id(a1) ; load obj75
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	move.b	d1,mainspr_childsprites(a1)
	subq.w	#1,d1
	lea	subspr_data(a1),a2

-	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#1,(a2)+	; sub?_mapframe
	dbf	d1,-

	move.w	d2,x_pos(a1)
	move.w	d3,y_pos(a1)
	move.b	#0,mainspr_mapframe(a1)
	move.l	a1,objoff_3C(a0)
	move.b	#$40,mainspr_height(a1)
	bset	#4,render_flags(a1)
; loc_28CCA:
Obj75_Main:
	moveq	#0,d0
	moveq	#0,d1
	move.w	objoff_34(a0),d0
	add.w	d0,angle(a0)
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo8_CalcSine
	move.w	objoff_32(a0),d2
	move.w	objoff_30(a0),d3
	moveq	#0,d6
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.b	mainspr_childsprites(a1),d6
	subq.w	#1,d6
	bcs.s	loc_28D3E
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	moveq	#0,d4
	moveq	#0,d5
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

	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,x_pos(a0)
	move.w	d4,y_pos(a0)
	move.w	sub6_x_pos(a1),x_pos(a1)
	move.w	sub6_y_pos(a1),y_pos(a1)

loc_28D3E:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	DisplaySprite, JmpTo22_DisplaySprite
; ===========================================================================
+
	move.w	objoff_30(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	DisplaySprite, JmpTo22_DisplaySprite
; ===========================================================================
+
	movea.l	objoff_3C(a0),a1 ; a1=object
	jsrto	DeleteObject2, JmpTo2_DeleteObject2
	jmpto	DeleteObject, JmpTo38_DeleteObject
; ===========================================================================

loc_28D6C:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo18_SolidObject
	jmpto	MarkObjGone, JmpTo22_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj75_MapUnc_28D8A:	include "mappings/sprite/obj75.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo22_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo38_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo22_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo2_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo15_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo38_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo8_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo18_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

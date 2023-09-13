; ===========================================================================
; ----------------------------------------------------------------------------
; Object 13 - Waterfall in Hidden Palace Zone (unused)
; ----------------------------------------------------------------------------
; Sprite_203AC:
Obj13:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj13_Index(pc,d0.w),d1
	jmp	Obj13_Index(pc,d1.w)
; ===========================================================================
; off_203BA
Obj13_Index:	offsetTable
		offsetTableEntry.w Obj13_Init	; 0
		offsetTableEntry.w Obj13_Main	; 2
		offsetTableEntry.w Obj13_ChkDel	; 4
; ===========================================================================
; loc_203C0:
Obj13_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj13_MapUnc_20528,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Waterfall,3,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo11_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$12,mapping_frame(a0)
	bsr.s	Obj13_LoadSubObject
	move.b	#$A0,y_radius(a1)
	bset	#4,render_flags(a1)
	move.l	a1,objoff_38(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	cmpi.b	#$10,subtype(a0)
	blo.s	loc_2046C
	bsr.s	Obj13_LoadSubObject
	move.l	a1,objoff_3C(a0)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$98,y_pos(a1)
	bra.s	loc_2046C
; ===========================================================================
; loc_20428:
Obj13_LoadSubObject:
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	+	; rts
	_move.b	#ObjID_HPZWaterfall,id(a1) ; load obj13
	addq.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	#Obj13_MapUnc_20528,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Waterfall,3,1),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo2_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#1,priority(a1)
+	rts
; ===========================================================================

loc_2046C:
	moveq	#0,d1
	move.b	subtype(a0),d1
	move.w	objoff_34(a0),d0
	subi.w	#$78,d0
	lsl.w	#4,d1
	add.w	d1,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_34(a0)
; loc_20486:
Obj13_Main:
	movea.l	objoff_38(a0),a1 ; a1=object
	move.b	#$12,mapping_frame(a0)
	move.w	objoff_34(a0),d0
	move.w	(Water_Level_1).w,d1
	cmp.w	d0,d1
	bhs.s	+
	move.w	d1,d0
+
	move.w	d0,y_pos(a0)
	sub.w	objoff_36(a0),d0
	addi.w	#$80,d0
	bmi.s	loc_204F0
	lsr.w	#4,d0
	move.w	d0,d1
	cmpi.w	#$F,d0
	blo.s	+
	moveq	#$F,d0
+
	move.b	d0,mapping_frame(a1)
	cmpi.b	#$10,subtype(a0)
	blo.s	loc_204D8
	movea.l	objoff_3C(a0),a1 ; a1=object
	subi.w	#$F,d1
	bcc.s	+
	moveq	#0,d1
+
	addi.w	#$13,d1
	move.b	d1,mapping_frame(a1)

loc_204D8:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo17_DeleteObject
	jmpto	DisplaySprite, JmpTo9_DisplaySprite
; ===========================================================================

loc_204F0:
	moveq	#$13,d0
	move.b	d0,mapping_frame(a0)
	move.b	d0,mapping_frame(a1)
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo17_DeleteObject
	rts
; ===========================================================================
; loc_20510:
Obj13_ChkDel:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo17_DeleteObject
	jmpto	DisplaySprite, JmpTo9_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings (unused)
; -------------------------------------------------------------------------------
Obj13_MapUnc_20528:	include "mappings/sprite/obj13.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo9_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo17_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo2_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo11_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    else
JmpTo17_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif

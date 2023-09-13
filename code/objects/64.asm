; ===========================================================================
; ----------------------------------------------------------------------------
; Object 64 - Twin stompers from MTZ
; ----------------------------------------------------------------------------
; Sprite_26920:
Obj64:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj64_Index(pc,d0.w),d1
	jmp	Obj64_Index(pc,d1.w)
; ===========================================================================
; off_2692E:
Obj64_Index:	offsetTable
		offsetTableEntry.w Obj64_Init	; 0
		offsetTableEntry.w Obj64_Main	; 2
; ===========================================================================
; byte_26932:
Obj64_Properties:
	;    width_pixels
	;	  objoff_2E
	dc.b $40, $C
	dc.b $40,  1	; 2
	dc.b $10,$20	; 4
	dc.b $40,  1	; 6
; ===========================================================================
; loc_2693A:
Obj64_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#2,d0
	andi.w	#$1C,d0
	lea	Obj64_Properties(pc,d0.w),a3
	move.b	(a3)+,width_pixels(a0)
	move.b	(a3)+,objoff_2E(a0)
	lsr.w	#2,d0
	move.b	d0,mapping_frame(a0)
	bne.s	+
	move.b	#$6C,y_radius(a0)
	bset	#4,render_flags(a0)
+
	move.l	#Obj64_MapUnc_26A5C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo28_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_30(a0)
	moveq	#0,d0
	move.b	(a3)+,d0
	move.w	d0,objoff_3C(a0)
	andi.b	#$F,subtype(a0)
; loc_269A2:
Obj64_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.w	Obj64_Modes(pc,d0.w),d1
	jsr	Obj64_Modes(pc,d1.w)
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	+
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	objoff_2E(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo9_SolidObject
+
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	JmpTo31_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

JmpTo31_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================
; off_269F4:
Obj64_Modes:	offsetTable
		offsetTableEntry.w return_269F8	; 0
		offsetTableEntry.w loc_269FA	; 2
; ===========================================================================

return_269F8:
	rts
; ===========================================================================

loc_269FA:
	tst.b	objoff_38(a0)
	bne.s	loc_26A1E
	tst.w	objoff_3A(a0)
	beq.s	loc_26A0C
	subq.w	#8,objoff_3A(a0)
	bra.s	loc_26A3E
; ===========================================================================

loc_26A0C:
	subq.w	#1,objoff_36(a0)
	bpl.s	loc_26A3E
	move.w	#$5A,objoff_36(a0)
	move.b	#1,objoff_38(a0)

loc_26A1E:
	move.w	objoff_3A(a0),d0
	cmp.w	objoff_3C(a0),d0
	beq.s	loc_26A2E
	addq.w	#8,objoff_3A(a0)
	bra.s	loc_26A3E
; ===========================================================================

loc_26A2E:
	subq.w	#1,objoff_36(a0)
	bpl.s	loc_26A3E
	move.w	#$5A,objoff_36(a0)
	clr.b	objoff_38(a0)

loc_26A3E:
	move.w	objoff_3A(a0),d0
	btst	#0,status(a0)
	beq.s	loc_26A50
	neg.w	d0
	addi.w	#$40,d0

loc_26A50:
	move.w	objoff_30(a0),d1
	add.w	d0,d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj64_MapUnc_26A5C:	include "mappings/sprite/obj64.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo28_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo9_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

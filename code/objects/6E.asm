; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6E - Platform moving in a circle (like at the start of MTZ3)
; ----------------------------------------------------------------------------
; Sprite_283AC:
Obj6E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6E_Index(pc,d0.w),d1
	jmp	Obj6E_Index(pc,d1.w)
; ===========================================================================
; off_283BA:
Obj6E_Index:	offsetTable
		offsetTableEntry.w Obj6E_Init	; 0
		offsetTableEntry.w loc_28432	; 2
		offsetTableEntry.w loc_284BC	; 4
; ===========================================================================
byte_283C0:
	;    width_pixels
	;        radius
	dc.b $10, $C
	dc.b $28,  8	; 2
	dc.b $60,$18	; 4
	dc.b  $C, $C	; 6
; ===========================================================================
; loc_283C8:
Obj6E_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj6E_MapUnc_2852C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo36_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	lea	byte_283C0(pc,d0.w),a3
	move.b	(a3)+,width_pixels(a0)
	move.b	(a3)+,y_radius(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_30(a0)
	cmpi.b	#3,d0
	bne.s	loc_28432
	addq.b	#2,routine(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzWheelIndent,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo36_Adjust2PArtPointer
	move.b	#5,priority(a0)
	bra.w	loc_284BC
; ===========================================================================

loc_28432:

	move.w	x_pos(a0),-(sp)
	move.b	(Oscillating_Data+$20).w,d1
	subi.b	#$38,d1
	ext.w	d1
	move.b	(Oscillating_Data+$24).w,d2
	subi.b	#$38,d2
	ext.w	d2
	btst	#0,subtype(a0)
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,subtype(a0)
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	add.w	objoff_34(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_30(a0),d2
	move.w	d2,y_pos(a0)
	move.w	(sp)+,d4
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo15_SolidObject
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmp	(DisplaySprite).l
; ===========================================================================
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	jmp	(DeleteObject).l
; ===========================================================================

loc_284BC:

	move.b	(Oscillating_Data+$20).w,d1
	lsr.b	#1,d1
	subi.b	#$1C,d1
	ext.w	d1
	move.b	(Oscillating_Data+$24).w,d2
	lsr.b	#1,d2
	subi.b	#$1C,d2
	ext.w	d2
	btst	#0,subtype(a0)
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,subtype(a0)
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	add.w	objoff_34(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_30(a0),d2
	move.w	d2,y_pos(a0)
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmp	(DisplaySprite).l
; ===========================================================================
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	jmp	(DeleteObject).l
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6E_MapUnc_2852C:	include "mappings/sprite/obj6E.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo36_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo15_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

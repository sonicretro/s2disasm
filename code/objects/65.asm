; ===========================================================================
; ----------------------------------------------------------------------------
; Object 65 - Long moving platform from MTZ
; ----------------------------------------------------------------------------
; Sprite_26AE0:
Obj65:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj65_Index(pc,d0.w),d1
	jmp	Obj65_Index(pc,d1.w)
; ===========================================================================
; off_26AEE:
Obj65_Index:	offsetTable
		offsetTableEntry.w Obj65_Init	; 0
		offsetTableEntry.w loc_26C1C	; 2
		offsetTableEntry.w loc_26EA4	; 4
		offsetTableEntry.w loc_26EC2	; 6
; ---------------------------------------------------------------------------
; byte_26AF6:
Obj65_Properties:
	;    width_pixels
	;	 radius
	dc.b $40, $C
	dc.b $80,  1	; 2
	dc.b $20, $C	; 4
	dc.b $40,  3	; 6
	dc.b $10,$10	; 8
	dc.b $20,  0	; 10
	dc.b $40, $C	; 12
	dc.b $80,  7	; 14
; ===========================================================================
; loc_26B06:
Obj65_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj65_Obj6A_Obj6B_MapUnc_26EC8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo29_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#2,d0
	andi.w	#$1C,d0
	lea	Obj65_Properties(pc,d0.w),a3
	move.b	(a3)+,width_pixels(a0)
	move.b	(a3)+,y_radius(a0)
	lsr.w	#2,d0
	move.b	d0,mapping_frame(a0)
	cmpi.b	#1,d0
	bne.s	+
	bset	#7,status(a0)
+
	cmpi.b	#2,d0
	bne.s	loc_26B6E
	addq.b	#4,routine(a0)
	move.l	#Obj65_MapUnc_26F04,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzCog,3,0),art_tile(a0)
	bra.w	loc_26EC2
; ===========================================================================

loc_26B6E:
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_30(a0)
	moveq	#0,d0
	move.b	(a3)+,d0
	move.w	d0,objoff_3C(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	bpl.w	loc_26C16
	andi.b	#$F,d0
	move.b	d0,objoff_3E(a0)
	move.b	(a3),subtype(a0)
	cmpi.b	#7,(a3)
	bne.s	+
	move.w	objoff_3C(a0),objoff_3A(a0)
+
	jsrto	AllocateObjectAfterCurrent, JmpTo11_AllocateObjectAfterCurrent
	bne.s	loc_26C04
	_move.b	id(a0),id(a1) ; load obj65
	addq.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#-$4C,x_pos(a1)
	addi.w	#$14,y_pos(a1)
	btst	#0,status(a0)
	bne.s	+
	subi.w	#-$18,x_pos(a1)
	bset	#0,render_flags(a1)
+
	move.l	#Obj65_MapUnc_26F04,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzCog,3,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	a0,objoff_3C(a1)

loc_26C04:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	loc_26C16
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

loc_26C16:
	andi.b	#$F,subtype(a0)

loc_26C1C:
	move.w	x_pos(a0),objoff_2E(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.w	off_26C7E(pc,d0.w),d1
	jsr	off_26C7E(pc,d1.w)
	move.w	objoff_2E(a0),d4
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi_.w	#5,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo10_SolidObject
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_26C66
	jmp	(DisplaySprite).l
; ===========================================================================

loc_26C66:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	jmp	(DeleteObject).l
; ===========================================================================
off_26C7E:	offsetTable
		offsetTableEntry.w return_26C8E	; 0
		offsetTableEntry.w loc_26CA4	; 1
		offsetTableEntry.w loc_26D34	; 2
		offsetTableEntry.w loc_26D94	; 3
		offsetTableEntry.w loc_26E3C	; 4
		offsetTableEntry.w loc_26E4A	; 5
		offsetTableEntry.w loc_26C90	; 6
		offsetTableEntry.w loc_26D14	; 7
; ===========================================================================

return_26C8E:
	rts
; ===========================================================================

loc_26C90:
	tst.b	objoff_38(a0)
	bne.s	BranchTo_loc_26CC2
	subq.w	#1,objoff_36(a0)
	bne.s	loc_26CD0
	move.b	#1,objoff_38(a0)

BranchTo_loc_26CC2 ; BranchTo
	bra.s	loc_26CC2
; ===========================================================================

loc_26CA4:
	tst.b	objoff_38(a0)
	bne.s	loc_26CC2
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	objoff_3E(a0),d0
	btst	#0,(a2,d0.w)
	beq.s	loc_26CD0
	move.b	#1,objoff_38(a0)

loc_26CC2:
	move.w	objoff_3C(a0),d0
	cmp.w	objoff_3A(a0),d0
	beq.s	loc_26CF2
	addq.w	#2,objoff_3A(a0)

loc_26CD0:
	move.w	objoff_3A(a0),d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	addi.w	#$80,d0
+
	move.w	objoff_34(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	move.w	d1,objoff_2E(a0)
	rts
; ===========================================================================

loc_26CF2:
	addq.b	#1,subtype(a0)
	move.w	#$B4,objoff_36(a0)
	clr.b	objoff_38(a0)
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	loc_26CD0
	bset	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bra.s	loc_26CD0
; ===========================================================================

loc_26D14:
	tst.b	objoff_38(a0)
	bne.s	+
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	objoff_3E(a0),d0
	btst	#0,(a2,d0.w)
	beq.s	loc_26D50
	move.b	#1,objoff_38(a0)
+
	bra.s	loc_26D46
; ===========================================================================

loc_26D34:
	tst.b	objoff_38(a0)
	bne.s	loc_26D46
	subq.w	#1,objoff_36(a0)
	bne.s	loc_26D50
	move.b	#1,objoff_38(a0)

loc_26D46:
	tst.w	objoff_3A(a0)
	beq.s	loc_26D72
	subq.w	#2,objoff_3A(a0)

loc_26D50:
	move.w	objoff_3A(a0),d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	addi.w	#$80,d0
+
	move.w	objoff_34(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	move.w	d1,objoff_2E(a0)
	rts
; ===========================================================================

loc_26D72:
	subq.b	#1,subtype(a0)
	move.w	#$B4,objoff_36(a0)
	clr.b	objoff_38(a0)
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	loc_26D50
	bclr	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bra.s	loc_26D50
; ===========================================================================

loc_26D94:
	move.w	objoff_34(a0),d4
	move.w	d4,d5
	btst	#0,status(a0)
	bne.s	loc_26DAC
	subi.w	#$20,d4
	addi.w	#$60,d5
	bra.s	loc_26DB4
; ===========================================================================

loc_26DAC:
	subi.w	#$A0,d4
	subi.w	#$20,d5

loc_26DB4:
	move.w	y_pos(a0),d2
	move.w	d2,d3
	subi.w	#$10,d2
	addi.w	#$40,d3
	moveq	#0,d1
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	d4,d0
	blo.s	+
	cmp.w	d5,d0
	bhs.s	+
	move.w	(MainCharacter+y_pos).w,d0
	cmp.w	d2,d0
	blo.s	+
	cmp.w	d3,d0
	bhs.s	+
	moveq	#1,d1
+
	move.w	(Sidekick+x_pos).w,d0
	cmp.w	d4,d0
	blo.s	+
	cmp.w	d5,d0
	bhs.s	+
	move.w	(Sidekick+y_pos).w,d0
	cmp.w	d2,d0
	blo.s	+
	cmp.w	d3,d0
	bhs.s	+
	moveq	#1,d1
+
	tst.b	d1
	beq.s	loc_26E0E
	move.w	objoff_3C(a0),d0
	cmp.w	objoff_3A(a0),d0
	beq.s	return_26E3A
	addi.w	#$10,objoff_3A(a0)
	bra.s	loc_26E1A
; ===========================================================================

loc_26E0E:
	tst.w	objoff_3A(a0)
	beq.s	loc_26E1A
	subi.w	#$10,objoff_3A(a0)

loc_26E1A:
	move.w	objoff_3A(a0),d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	addi.w	#$40,d0
+
	move.w	objoff_34(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	move.w	d1,objoff_2E(a0)

return_26E3A:
	rts
; ===========================================================================

loc_26E3C:
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	addq.b	#1,subtype(a0)
+
	rts
; ===========================================================================

loc_26E4A:
	tst.b	objoff_38(a0)
	bne.s	loc_26E84
	addq.w	#2,x_pos(a0)
	cmpi.b	#metropolis_zone_2,(Current_Zone).w
	bne.s	loc_26E74
	cmpi.w	#$1CC0,x_pos(a0)
	beq.s	loc_26E6C
	cmpi.w	#$2940,x_pos(a0)
	bne.s	loc_26E96

loc_26E6C:
	move.b	#0,subtype(a0)
	bra.s	loc_26E96
; ===========================================================================

loc_26E74:
	cmpi.w	#$1BC0,x_pos(a0)
	bne.s	loc_26E96
	move.b	#1,objoff_38(a0)
	bra.s	loc_26E96
; ===========================================================================

loc_26E84:
	subq.w	#2,x_pos(a0)
	cmpi.w	#$1880,x_pos(a0)
	bne.s	loc_26E96
	move.b	#0,objoff_38(a0)

loc_26E96:
	move.w	x_pos(a0),objoff_34(a0)
	move.w	x_pos(a0),(MTZ_Platform_Cog_X).w
	rts
; ===========================================================================

loc_26EA4:
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.w	objoff_3A(a1),d0

loc_26EAC:
	andi.w	#7,d0
	move.b	byte_26EBA(pc,d0.w),mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo19_MarkObjGone
; ===========================================================================
byte_26EBA:
	dc.b   0
	dc.b   0	; 1
	dc.b   2	; 2
	dc.b   2	; 3
	dc.b   2	; 4
	dc.b   1	; 5
	dc.b   1	; 6
	dc.b   1	; 7
	even
; ===========================================================================

loc_26EC2:
	move.w	(MTZ_Platform_Cog_X).w,d0
	bra.s	loc_26EAC
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj65_Obj6A_Obj6B_MapUnc_26EC8:	include "mappings/sprite/obj65_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj65_MapUnc_26F04:	include "mappings/sprite/obj65_b.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo19_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo11_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo29_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo10_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

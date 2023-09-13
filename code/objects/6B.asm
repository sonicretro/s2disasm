; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6B - Immobile platform from MTZ
; ----------------------------------------------------------------------------
; Sprite_27D6C:
Obj6B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6B_Index(pc,d0.w),d1
	jmp	Obj6B_Index(pc,d1.w)
; ===========================================================================
; off_27D7A:
Obj6B_Index:	offsetTable
		offsetTableEntry.w Obj6B_Init	; 0
		offsetTableEntry.w Obj6B_Main	; 2
; ===========================================================================
byte_27D7E:
	dc.b $20
	dc.b  $C	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b $10	; 4
	dc.b $10	; 5
	dc.b   0	; 6
	dc.b   0	; 7
	even
; ===========================================================================
; loc_27D86:
Obj6B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj65_Obj6A_Obj6B_MapUnc_26EC8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj6B_MapUnc_2800E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0),art_tile(a0)
+
	jsrto	Adjust2PArtPointer, JmpTo34_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#2,d0
	andi.w	#$1C,d0
	lea	byte_27D7E(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_30(a0)
	move.b	status(a0),objoff_2E(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	subq.w	#8,d0
	bcs.s	Obj6B_Main
	lsl.w	#2,d0
	lea	(Oscillating_Data+$2A).w,a2
	lea	(a2,d0.w),a2
	tst.w	(a2)
	bpl.s	Obj6B_Main
	bchg	#0,objoff_2E(a0)
; loc_27E0E:
Obj6B_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	add.w	d0,d0
	move.w	Obj6B_Types(pc,d0.w),d1
	jsr	Obj6B_Types(pc,d1.w)
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	+
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo14_SolidObject
+
	move.w	objoff_34(a0),d0
	jmpto	MarkObjGone2, JmpTo4_MarkObjGone2
; ===========================================================================
; off_27E4E:
Obj6B_Types:	offsetTable
		offsetTableEntry.w Obj6B_Type_Immobile	;  0
		offsetTableEntry.w loc_27E68		;  1
		offsetTableEntry.w loc_27E74		;  2
		offsetTableEntry.w loc_27E96		;  3
		offsetTableEntry.w loc_27EA2		;  4
		offsetTableEntry.w loc_27EC4		;  5
		offsetTableEntry.w loc_27EE2		;  6
		offsetTableEntry.w loc_27F10		;  7
		offsetTableEntry.w loc_27F4E		;  8
		offsetTableEntry.w loc_27F60		;  9
		offsetTableEntry.w loc_27F70		; $A
		offsetTableEntry.w loc_27F80		; $B
; ===========================================================================
; return_27E66:
Obj6B_Type_Immobile:
	rts
; ===========================================================================

loc_27E68:
	move.w	#$40,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+8).w,d0
	bra.s	+
; ===========================================================================

loc_27E74:
	move.w	#$80,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$1C).w,d0
+
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	add.w	d1,d0
+
	move.w	objoff_34(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_27E96:
	move.w	#$40,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+8).w,d0
	bra.s	loc_27EAC
; ===========================================================================

loc_27EA2:
	move.w	#$80,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$1C).w,d0

loc_27EAC:
	btst	#0,status(a0)
	beq.s	loc_27EB8
	neg.w	d0
	add.w	d1,d0

loc_27EB8:
	move.w	objoff_30(a0),d1
	sub.w	d0,d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_27EC4:
	move.b	(Oscillating_Data).w,d0
	lsr.w	#1,d0
	add.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	move.b	status(a0),d1
	andi.b	#standing_mask,d1
	beq.s	return_27EE0
	addq.b	#1,subtype(a0)

return_27EE0:
	rts
; ===========================================================================

loc_27EE2:
	move.l	y_pos(a0),d3
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,y_pos(a0)
	addi_.w	#8,y_vel(a0)
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#224,d0
	cmp.w	y_pos(a0),d0
	bhs.s	return_27F0E
	move.b	#0,subtype(a0)

return_27F0E:
	rts
; ===========================================================================

loc_27F10:
	tst.b	objoff_38(a0)
	bne.s	loc_27F26
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_27F4C
	move.b	#8,objoff_38(a0)

loc_27F26:
	jsrto	ObjectMove, JmpTo14_ObjectMove
	andi.w	#$7FF,y_pos(a0)
	cmpi.w	#$2A8,y_vel(a0)
	bne.s	loc_27F3C
	neg.b	objoff_38(a0)

loc_27F3C:
	move.b	objoff_38(a0),d1
	ext.w	d1
	add.w	d1,y_vel(a0)
	bne.s	return_27F4C
	clr.b	subtype(a0)

return_27F4C:
	rts
; ===========================================================================

loc_27F4E:
	move.w	#$10,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$28).w,d0
	lsr.w	#1,d0
	move.w	(Oscillating_Data+$2A).w,d3
	bra.s	loc_27F8E
; ===========================================================================

loc_27F60:
	move.w	#$30,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$2C).w,d0
	move.w	(Oscillating_Data+$2E).w,d3
	bra.s	loc_27F8E
; ===========================================================================

loc_27F70:
	move.w	#$50,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$30).w,d0
	move.w	(Oscillating_Data+$32).w,d3
	bra.s	loc_27F8E
; ===========================================================================

loc_27F80:
	move.w	#$70,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$34).w,d0
	move.w	(Oscillating_Data+$36).w,d3

loc_27F8E:
	tst.w	d3
	bne.s	loc_27F9C
	addq.b	#1,objoff_2E(a0)
	andi.b	#3,objoff_2E(a0)

loc_27F9C:
	move.b	objoff_2E(a0),d2
	andi.b	#3,d2
	bne.s	loc_27FBC
	sub.w	d1,d0
	add.w	objoff_34(a0),d0
	move.w	d0,x_pos(a0)
	neg.w	d1
	add.w	objoff_30(a0),d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_27FBC:
	subq.b	#1,d2
	bne.s	loc_27FDA
	subq.w	#1,d1
	sub.w	d1,d0
	neg.w	d0
	add.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	addq.w	#1,d1
	add.w	objoff_34(a0),d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_27FDA:
	subq.b	#1,d2
	bne.s	loc_27FF8
	subq.w	#1,d1
	sub.w	d1,d0
	neg.w	d0
	add.w	objoff_34(a0),d0
	move.w	d0,x_pos(a0)
	addq.w	#1,d1
	add.w	objoff_30(a0),d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_27FF8:
	sub.w	d1,d0
	add.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	neg.w	d1
	add.w	objoff_34(a0),d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6B_MapUnc_2800E:	include "mappings/sprite/obj6B.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo34_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo14_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo4_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l
; loc_2802E:
JmpTo14_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif

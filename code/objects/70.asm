; ===========================================================================
; ----------------------------------------------------------------------------
; Object 70 - Giant rotating cog from MTZ
; ----------------------------------------------------------------------------
; Sprite_285C0:
Obj70:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj70_Index(pc,d0.w),d1
	jmp	Obj70_Index(pc,d1.w)
; ===========================================================================
; off_285CE:
Obj70_Index:	offsetTable
		offsetTableEntry.w Obj70_Init	; 0
		offsetTableEntry.w Obj70_Main	; 2
; ===========================================================================
; loc_285D2:
Obj70_Init:
	moveq	#7,d1
	moveq	#0,d4
	lea	(Obj70_Positions).l,a2
	movea.l	a0,a1
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	bset	#7,status(a0)
	bra.s	Obj70_LoadSubObject
; ===========================================================================
; loc_285EE:
Obj70_SubObjectLoop:
	jsrto	AllocateObjectAfterCurrent, JmpTo14_AllocateObjectAfterCurrent
	bne.s	+
; loc_285F4:
Obj70_LoadSubObject:
	_move.b	id(a0),id(a1) ; load obj70
	addq.b	#2,routine(a1)
	move.l	#Obj70_MapUnc_28786,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzWheel,3,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo4_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.w	d2,objoff_32(a1)
	move.w	d3,objoff_30(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.w	d4,objoff_34(a1)
	addq.w	#3,d4
	move.b	status(a0),status(a1)
+
	dbf	d1,Obj70_SubObjectLoop
; loc_28652:
Obj70_Main:
	move.w	x_pos(a0),-(sp)
	move.b	(Timer_frames+1).w,d0
	move.b	d0,d1
	andi.w	#$F,d0
	bne.s	loc_286CA
	move.w	objoff_36(a0),d1
	btst	#0,status(a0)
	beq.s	loc_28684
	subi.w	#$18,d1
	bcc.s	loc_286A2
	moveq	#$48,d1
	subq.w	#3,objoff_34(a0)
	bcc.s	loc_286A2
	move.w	#$15,objoff_34(a0)
	bra.s	loc_286A2
; ===========================================================================

loc_28684:
	addi.w	#$18,d1
	cmpi.w	#$60,d1
	blo.s	loc_286A2
	moveq	#0,d1
	addq.w	#3,objoff_34(a0)
	cmpi.w	#$18,objoff_34(a0)
	blo.s	loc_286A2
	move.w	#0,objoff_34(a0)

loc_286A2:
	move.w	d1,objoff_36(a0)
	add.w	objoff_34(a0),d1
	lea	Obj70_Positions(pc,d1.w),a1
	move.b	(a1)+,d0
	ext.w	d0
	add.w	objoff_32(a0),d0
	move.w	d0,x_pos(a0)
	move.b	(a1)+,d0
	ext.w	d0
	add.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	move.b	(a1)+,mapping_frame(a0)

loc_286CA:
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	andi.w	#$1E,d0
	moveq	#0,d1
	moveq	#0,d2
	move.b	byte_28706(pc,d0.w),d1
	move.b	byte_28706+1(pc,d0.w),d2
	move.w	d2,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo16_SolidObject
	move.w	objoff_32(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmp	(DisplaySprite).l
; ===========================================================================
+
	jmp	(DeleteObject).l
; ===========================================================================
byte_28706:
	dc.b $10,$10	; 0
	dc.b $10,$10	; 2
	dc.b $10,$10	; 4
	dc.b $10,$10	; 6
	dc.b $10,$10	; 8
	dc.b $10,$10	; 10
	dc.b $10,$10	; 12
	dc.b $10, $C	; 14
	dc.b $10,  8	; 16
	dc.b $10, $C	; 18
	dc.b $10,$10	; 20
	dc.b $10,$10	; 22
	dc.b $10,$10	; 24
	dc.b $10,$10	; 26
	dc.b $10,$10	; 28
	dc.b $10,$10	; 30
; byte_28726:
Obj70_Positions:
	; initial positions
	; x_pos, y_pos, mapping_frame
	dc.b   0,$B8,  0
	dc.b $32,$CE,  4
	dc.b $48,  0,  8
	dc.b $32,$32, $C
	dc.b   0,$48,$10
	dc.b $CE,$32,$14
	dc.b $B8,  0,$18
	dc.b $CE,$CE,$1C

	dc.b  $D,$B8,  1
	dc.b $3F,$DA,  5
	dc.b $48, $C,  9
	dc.b $27,$3C, $D
	dc.b $F3,$48,$11
	dc.b $C1,$26,$15
	dc.b $B8,$F4,$19
	dc.b $D9,$C4,$1D

	dc.b $19,$BC,  2
	dc.b $46,$E9,  6
	dc.b $46,$17, $A
	dc.b $19,$44, $E
	dc.b $E7,$44,$12
	dc.b $BA,$17,$16
	dc.b $BA,$E9,$1A
	dc.b $E7,$BC,$1E

	dc.b $27,$C4,  3
	dc.b $48,$F4,  7
	dc.b $3F,$26, $B
	dc.b  $D,$48, $F
	dc.b $D9,$3C,$13
	dc.b $B8, $C,$17
	dc.b $C1,$DA,$1B
	dc.b $F3,$B8,$1F
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj70_MapUnc_28786:	include "mappings/sprite/obj70.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo14_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo4_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo16_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif

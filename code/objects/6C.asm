; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6C - Small platform on pulleys (like at the start of MTZ2)
; ----------------------------------------------------------------------------
; Sprite_28034:
Obj6C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6C_Index(pc,d0.w),d1
	jsr	Obj6C_Index(pc,d1.w)
	move.w	objoff_30(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmpto	DisplaySprite, JmpTo20_DisplaySprite
; ===========================================================================
+	jmpto	DeleteObject, JmpTo34_DeleteObject
; ===========================================================================
; off_2805C:
Obj6C_Index:	offsetTable
		offsetTableEntry.w Obj6C_Init	; 0
		offsetTableEntry.w Obj6C_Main	; 2
; ===========================================================================
; loc_28060:
Obj6C_Init:
	move.b	subtype(a0),d0
	bmi.w	loc_28112
	addq.b	#2,routine(a0)
	move.l	#Obj6C_MapUnc_28372,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_LavaCup,3,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	jsrto	Adjust2PArtPointer, JmpTo35_Adjust2PArtPointer
	move.b	#0,mapping_frame(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	d0,d1
	lsr.w	#3,d0
	andi.w	#$1E,d0
	lea	off_28252(pc),a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,objoff_38(a0)
	move.l	a2,objoff_3C(a0)
	andi.w	#$F,d1
	lsl.w	#2,d1
	move.b	d1,objoff_38(a0)
	move.b	#4,objoff_3A(a0)
	btst	#0,status(a0)
	beq.s	loc_280F2
	neg.b	objoff_3A(a0)
	moveq	#0,d1
	move.b	objoff_38(a0),d1
	add.b	objoff_3A(a0),d1
	cmp.b	objoff_39(a0),d1
	blo.s	loc_280EE
	move.b	d1,d0
	moveq	#0,d1
	tst.b	d0
	bpl.s	loc_280EE
	move.b	objoff_39(a0),d1
	subq.b	#4,d1

loc_280EE:
	move.b	d1,objoff_38(a0)

loc_280F2:
	move.w	(a2,d1.w),d0
	add.w	objoff_30(a0),d0
	move.w	d0,objoff_34(a0)
	move.w	2(a2,d1.w),d0
	add.w	objoff_32(a0),d0
	move.w	d0,objoff_36(a0)
	bsr.w	loc_281DA
	bra.w	Obj6C_Main
; ===========================================================================

loc_28112:
	andi.w	#$7F,d0
	add.w	d0,d0
	lea	(off_282D6).l,a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d1
	movea.l	a0,a1
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	bra.s	Obj6C_LoadSubObject
; ===========================================================================
; loc_28130:
Obj6C_SubObjectsLoop:
	jsrto	AllocateObject, JmpTo8_AllocateObject
	bne.s	+
; loc_28136:
Obj6C_LoadSubObject:
	_move.b	#ObjID_Conveyor,id(a1) ; load obj6C
	move.w	(a2)+,d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.w	(a2)+,d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.w	d2,objoff_30(a1)
	move.w	d3,objoff_32(a1)
	move.w	(a2)+,d0
	move.b	d0,subtype(a1)
	move.b	status(a0),status(a1)
+
	dbf	d1,Obj6C_SubObjectsLoop
	addq.l	#4,sp
	rts
; ===========================================================================
; loc_28168:
Obj6C_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	loc_2817E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	jmpto	PlatformObject, JmpTo5_PlatformObject
; ===========================================================================

loc_2817E:
	move.w	x_pos(a0),d0
	cmp.w	objoff_34(a0),d0
	bne.s	loc_281D4
	move.w	y_pos(a0),d0
	cmp.w	objoff_36(a0),d0
	bne.s	loc_281D4
	moveq	#0,d1
	move.b	objoff_38(a0),d1
	add.b	objoff_3A(a0),d1
	cmp.b	objoff_39(a0),d1
	blo.s	loc_281B0
	move.b	d1,d0
	moveq	#0,d1
	tst.b	d0
	bpl.s	loc_281B0
	move.b	objoff_39(a0),d1
	subq.b	#4,d1

loc_281B0:
	move.b	d1,objoff_38(a0)
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.w	(a1,d1.w),d0
	add.w	objoff_30(a0),d0
	move.w	d0,objoff_34(a0)
	move.w	2(a1,d1.w),d0
	add.w	objoff_32(a0),d0
	move.w	d0,objoff_36(a0)
	bsr.w	loc_281DA

loc_281D4:
	jsrto	ObjectMove, JmpTo15_ObjectMove
	rts
; ===========================================================================

loc_281DA:
	moveq	#0,d0
	move.w	#-$100,d2
	move.w	x_pos(a0),d0
	sub.w	objoff_34(a0),d0
	bcc.s	loc_281EE
	neg.w	d0
	neg.w	d2

loc_281EE:
	moveq	#0,d1
	move.w	#-$100,d3
	move.w	y_pos(a0),d1
	sub.w	objoff_36(a0),d1
	bcc.s	loc_28202
	neg.w	d1
	neg.w	d3

loc_28202:
	cmp.w	d0,d1
	blo.s	loc_2822C
	move.w	x_pos(a0),d0
	sub.w	objoff_34(a0),d0
	beq.s	loc_28218
	ext.l	d0
	asl.l	#8,d0
	divs.w	d1,d0
	neg.w	d0

loc_28218:
	move.w	d0,x_vel(a0)
	move.w	d3,y_vel(a0)
	swap	d0
	move.w	d0,x_sub(a0)
	clr.w	y_sub(a0)
	rts
; ===========================================================================

loc_2822C:
	move.w	y_pos(a0),d1
	sub.w	objoff_36(a0),d1
	beq.s	loc_2823E
	ext.l	d1
	asl.l	#8,d1
	divs.w	d0,d1
	neg.w	d1

loc_2823E:
	move.w	d1,y_vel(a0)
	move.w	d2,x_vel(a0)
	swap	d1
	move.w	d1,y_sub(a0)
	clr.w	x_sub(a0)
	rts
; ===========================================================================
off_28252:	offsetTable
		offsetTableEntry.w byte_28258	; 0
		offsetTableEntry.w byte_28282	; 1
		offsetTableEntry.w byte_282AC	; 2
byte_28258:
	dc.b   0,$28,  0,  0,  0,  0,$FF,$EA,  0, $A,$FF,$E0,  0,$20,$FF,$E0
	dc.b   0,$E0,$FF,$EA,  0,$F6,  0,  0,  1,  0,  0,$16,  0,$F6,  0,$20; 16
	dc.b   0,$E0,  0,$20,  0,$20,  0,$16,  0, $A; 32
byte_28282:
	dc.b   0,$28,  0,  0,  0,  0,$FF,$EA,  0, $A,$FF,$E0,  0,$20,$FF,$E0
	dc.b   1,$60,$FF,$EA,  1,$76,  0,  0,  1,$80,  0,$16,  1,$76,  0,$20; 16
	dc.b   1,$60,  0,$20,  0,$20,  0,$16,  0, $A; 32
byte_282AC:
	dc.b   0,$28,  0,  0,  0,  0,$FF,$EA,  0, $A,$FF,$E0,  0,$20,$FF,$E0
	dc.b   1,$E0,$FF,$EA,  1,$F6,  0,  0,  2,  0,  0,$16,  1,$F6,  0,$20; 16
	dc.b   1,$E0,  0,$20,  0,$20,  0,$16,  0, $A; 32
	even
; ---------------------------------------------------------------------------
off_282D6:	offsetTable
		offsetTableEntry.w byte_282DC	; 0
		offsetTableEntry.w byte_2830E	; 1
		offsetTableEntry.w byte_28340	; 2
byte_282DC:
	dc.b   0,  7,  0,  0,  0,  0,  0,  1,$FF,$E0,  0,$3A,  0,  3,$FF,$E0
	dc.b   0,$80,  0,  3,$FF,$E0,  0,$C6,  0,  3,  0,  0,  1,  0,  0,  6; 16
	dc.b   0,$20,  0,$C6,  0,  8,  0,$20,  0,$80,  0,  8,  0,$20,  0,$3A; 32
	dc.b   0,  8	; 48
byte_2830E:
	dc.b   0,  7,  0,  0,  0,  0,  0,$11,$FF,$E0,  0,$5A,  0,$13,$FF,$E0
	dc.b   0,$C0,  0,$13,$FF,$E0,  1,$26,  0,$13,  0,  0,  1,$80,  0,$16; 16
	dc.b   0,$20,  1,$26,  0,$18,  0,$20,  0,$C0,  0,$18,  0,$20,  0,$5A; 32
	dc.b   0,$18	; 48
byte_28340:
	dc.b   0,  7,  0,  0,  0,  0,  0,$21,$FF,$E0,  0,$7A,  0,$23,$FF,$E0
	dc.b   1,  0,  0,$23,$FF,$E0,  1,$86,  0,$23,  0,  0,  2,  0,  0,$26; 16
	dc.b   0,$20,  1,$86,  0,$28,  0,$20,  1,  0,  0,$28,  0,$20,  0,$7A; 32
	dc.b   0,$28	; 48
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6C_MapUnc_28372:	include "mappings/sprite/obj6C.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo20_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo34_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo8_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo35_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo5_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
; loc_283A6:
JmpTo15_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif

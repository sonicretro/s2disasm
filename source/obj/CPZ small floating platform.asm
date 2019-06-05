; ----------------------------------------------------------------------------
; Object 0C - Small floating platform (unused)
; (used in CPZ in the Nick Arcade prototype)
; ----------------------------------------------------------------------------
; Sprite_20210:
Obj0C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0C_Index(pc,d0.w),d1
	jmp	Obj0C_Index(pc,d1.w)
; ===========================================================================
; off_2021E
Obj0C_Index:	offsetTable
		offsetTableEntry.w Obj0C_Init	; 0
		offsetTableEntry.w Obj0C_Main	; 2
; ===========================================================================
; loc_20222:
Obj0C_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj0C_MapUnc_202FA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FloatPlatform,3,1),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo9_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,objoff_3A(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F0,d0
	addi.w	#$10,d0
	move.w	d0,d1
	subq.w	#1,d0
	move.w	d0,objoff_30(a0)
	move.w	d0,objoff_32(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	move.b	d0,objoff_3E(a0)
	move.b	d0,objoff_3F(a0)
; loc_20282:
Obj0C_Main:
	move.b	objoff_3C(a0),d0
	beq.s	loc_202C0
	cmpi.b	#$80,d0
	bne.s	loc_202D0
	move.b	objoff_3D(a0),d1
	bne.s	loc_202A2
	subq.b	#1,objoff_3E(a0)
	bpl.s	loc_202A2
	move.b	objoff_3F(a0),objoff_3E(a0)
	bra.s	loc_202D0
; ===========================================================================

loc_202A2:
	addq.b	#1,objoff_3D(a0)
	move.b	d1,d0
	jsrto	(CalcSine).l, JmpTo5_CalcSine
	addi_.w	#8,d0
	asr.w	#6,d0
	subi.w	#$10,d0
	add.w	objoff_3A(a0),d0
	move.w	d0,y_pos(a0)
	bra.s	loc_202E6
; ===========================================================================

loc_202C0:
	move.w	(Vint_runcount+2).w,d1
	andi.w	#$3FF,d1
	bne.s	loc_202D4
	move.b	#1,objoff_3D(a0)

loc_202D0:
	addq.b	#1,objoff_3C(a0)

loc_202D4:
	jsrto	(CalcSine).l, JmpTo5_CalcSine
	addi_.w	#8,d1
	asr.w	#4,d1
	add.w	objoff_3A(a0),d1
	move.w	d1,y_pos(a0)

loc_202E6:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#9,d3
	move.w	x_pos(a0),d4
	bsr.w	PlatformObject
	jmpto	(MarkObjGone).l, JmpTo4_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Unused sprite mappings
; ----------------------------------------------------------------------------
Obj0C_MapUnc_202FA:	BINCLUDE "mappings/sprite/obj0C.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo4_MarkObjGone 
	jmp	(MarkObjGone).l
JmpTo9_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l
JmpTo5_CalcSine 
	jmp	(CalcSine).l

	align 4
    endif

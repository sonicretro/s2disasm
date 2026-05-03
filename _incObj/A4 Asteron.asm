; ----------------------------------------------------------------------------
; Object A4 - Asteron (exploding starfish badnik) from MTZ
; ----------------------------------------------------------------------------
; Sprite_3899C:
ObjA4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA4_Index(pc,d0.w),d1
	jmp	ObjA4_Index(pc,d1.w)
; ===========================================================================
; off_389AA:
ObjA4_Index:	offsetTable
		offsetTableEntry.w ObjA4_Init	; 0
		offsetTableEntry.w loc_389B6	; 2
		offsetTableEntry.w loc_389DA	; 4
		offsetTableEntry.w loc_38A2C	; 6
; ===========================================================================
; BranchTo3_LoadSubObject
ObjA4_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_389B6:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	bhs.s	BranchTo6_JmpTo39_MarkObjGone
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	blo.s	loc_389D2

BranchTo6_JmpTo39_MarkObjGone ; BranchTo
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_389D2:
	addq.b	#2,routine(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_389DA:
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$10,d2
	blo.s	loc_389FA
	cmpi.w	#$60,d2
	bhs.s	loc_389FA
	move.w	word_38A1A(pc,d0.w),x_vel(a0)
	bsr.w	loc_38A1E

loc_389FA:
	abs.w	d3
	cmpi.w	#$10,d3
	blo.s	BranchTo7_JmpTo39_MarkObjGone
	cmpi.w	#$60,d3
	bhs.s	BranchTo7_JmpTo39_MarkObjGone
	move.w	word_38A1A(pc,d1.w),y_vel(a0)
	bsr.w	loc_38A1E

BranchTo7_JmpTo39_MarkObjGone ; BranchTo
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
word_38A1A:
	dc.w  -$40	; 0
	dc.w   $40	; 1
; ===========================================================================

loc_38A1E:
	move.b	#6,routine(a0)
	move.b	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_38A2C:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_38A44
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objA4).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38A44:
	_move.b	#ObjID_Explosion,id(a0) ; load 0bj27
	move.b	#2,routine(a0)
	bsr.w	loc_38A58
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38A58:
	move.b	#$30,d2
	moveq	#word_38A68.counter,d6
	lea	(word_38A68).l,a2
	bra.w	Obj_CreateProjectiles
; ===========================================================================
word_38A68:
	dc.b  0,-8
	dc.b  0,-4
	dc.b  2
	dc.b  FALSE<<render_flags.x_flip

	dc.b  8,-4
	dc.b  3,-1
	dc.b  3
	dc.b   TRUE<<render_flags.x_flip

	dc.b  8, 8
	dc.b  3, 3
	dc.b  4
	dc.b   TRUE<<render_flags.x_flip

	dc.b -8, 8
	dc.b -3, 3
	dc.b  4
	dc.b  FALSE<<render_flags.x_flip

	dc.b -8,-4
	dc.b -3,-1
	dc.b  3
	dc.b  FALSE<<render_flags.x_flip
word_38A68.end:
word_38A68.counter = ((word_38A68.end - word_38A68) / 6) - 1

; off_38A86:
ObjA4_SubObjData:
	subObjData ObjA4_Obj98_MapUnc_38A96,make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1),1<<render_flags.level_fg,4,$10,$B

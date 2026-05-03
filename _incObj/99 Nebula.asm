; ----------------------------------------------------------------------------
; Object 99 - Nebula (bomber badnik) from SCZ
; ----------------------------------------------------------------------------
; Sprite_377C8:
Obj99:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj99_Index(pc,d0.w),d1
	jmp	Obj99_Index(pc,d1.w)
; ===========================================================================
; off_377D6:
Obj99_Index:	offsetTable
		offsetTableEntry.w Obj99_Init
		offsetTableEntry.w loc_377E8
		offsetTableEntry.w loc_3781C
; ===========================================================================
; loc_377DC:
Obj99_Init:
	bsr.w	LoadSubObject
	move.w	#-$C0,x_vel(a0)
	rts
; ===========================================================================

loc_377E8:
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	bne.s	loc_377FA
	cmpi.w	#$80,d2
	bhs.s	loc_377FA
	bsr.w	loc_37810

loc_377FA:
	jsrto	JmpTo26_ObjectMove
	bsr.w	loc_36776
	lea	(Ani_obj99).l,a1
	jsrto	JmpTo25_AnimateSprite
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================

loc_37810:
	addq.b	#2,routine(a0)
	move.w	#-$A0,y_vel(a0)
	rts
; ===========================================================================

loc_3781C:
	tst.b	objoff_2A(a0)
	bne.s	loc_37834
	bsr.w	Obj_GetOrientationToPlayer
	addi_.w	#8,d2
	cmpi.w	#$10,d2
	bhs.s	loc_37834
	bsr.w	loc_37850

loc_37834:
	addi_.w	#1,y_vel(a0)
	jsrto	JmpTo26_ObjectMove
	bsr.w	loc_36776
	lea	(Ani_obj99).l,a1
	jsrto	JmpTo25_AnimateSprite
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================

loc_37850:
	st.b	objoff_2A(a0)
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_37886
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#4,mapping_frame(a1)
	move.b	#$14,subtype(a1) ; <== Obj99_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$18,y_pos(a1)
	lea_	Obj98_NebulaBombFall,a2
	move.l	a2,objoff_2A(a1)

return_37886:
	rts
; ===========================================================================
; off_37888:
Obj99_SubObjData2:
	subObjData Obj99_Obj98_MapUnc_3789A,make_art_tile(ArtTile_ArtNem_Nebula,1,1),1<<render_flags.level_fg,4,$10,6

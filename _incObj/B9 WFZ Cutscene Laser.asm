; ----------------------------------------------------------------------------
; Object B9 - Laser from WFZ that shoots down the Tornado
; ----------------------------------------------------------------------------
; Sprite_3BABA:
ObjB9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB9_Index(pc,d0.w),d1
	jmp	ObjB9_Index(pc,d1.w)
; ===========================================================================
; off_3BAC8:
ObjB9_Index:	offsetTable
		offsetTableEntry.w ObjB9_Init
		offsetTableEntry.w loc_3BAD2
		offsetTableEntry.w loc_3BAF0
; ===========================================================================
; BranchTo6_LoadSubObject
ObjB9_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3BAD2:
	_btst	#render_flags.on_screen,render_flags(a0)
	_bne.s	+
	bra.w	loc_3BAF8
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#-$1000,x_vel(a0)
	moveq	#signextendB(SndID_LargeLaser),d0
	jsrto	JmpTo12_PlaySound
	bra.w	loc_3BAF8
; ===========================================================================

loc_3BAF0:
	jsrto	JmpTo26_ObjectMove
	bra.w	loc_3BAF8
loc_3BAF8:
	move.w	x_pos(a0),d0
	move.w	(Camera_X_pos).w,d1
	subi.w	#$40,d1
	cmp.w	d1,d0
	blt.w	JmpTo65_DeleteObject
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; off_3BB0E:
ObjB9_SubObjData:
	subObjData ObjB9_MapUnc_3BB18,make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1),1<<render_flags.level_fg,1,$60,0

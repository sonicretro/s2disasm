; ----------------------------------------------------------------------------
; Object BF - Rotaty-stick badnik from WFZ
; Perhaps this was to be paired with B5 for a destructible propeller hazard?
; ----------------------------------------------------------------------------
; Sprite_3BEAA:
ObjBF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBF_Index(pc,d0.w),d1
	jmp	ObjBF_Index(pc,d1.w)
; ===========================================================================
; off_3BEB8:
ObjBF_Index:	offsetTable
		offsetTableEntry.w ObjBF_Init		; 0
		offsetTableEntry.w ObjBF_Animate	; 2
; ===========================================================================
; BranchTo9_LoadSubObject
ObjBF_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3BEC0:
ObjBF_Animate:
	lea	(Ani_objBF).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BECE:
ObjBE_SubObjData2:
	subObjData ObjBF_MapUnc_3BEE0,make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1),1<<render_flags.level_fg,4,4,4

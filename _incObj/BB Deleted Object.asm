; ----------------------------------------------------------------------------
; Object BB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_3BB7C:
ObjBB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBB_Index(pc,d0.w),d1
	jmp	ObjBB_Index(pc,d1.w)
; ===========================================================================
; off_3BB8A:
ObjBB_Index:	offsetTable
		offsetTableEntry.w ObjBB_Init	; 0
		offsetTableEntry.w ObjBB_Main	; 2
; ===========================================================================
; BranchTo8_LoadSubObject
ObjBB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo15_JmpTo39_MarkObjGone
ObjBB_Main:
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB96:
ObjBB_SubObjData:
	subObjData ObjBB_MapUnc_3BBA0,make_art_tile(ArtTile_ArtNem_Unknown,1,0),1<<render_flags.level_fg,4,$C,9

; ----------------------------------------------------------------------------
; Object BA - Wheel from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BB4C:
ObjBA:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBA_Index(pc,d0.w),d1
	jmp	ObjBA_Index(pc,d1.w)
; ===========================================================================
; off_3BB5A:
ObjBA_Index:	offsetTable
		offsetTableEntry.w ObjBA_Init	; 0
		offsetTableEntry.w ObjBA_Main	; 2
; ===========================================================================
; BranchTo7_LoadSubObject
ObjBA_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo14_JmpTo39_MarkObjGone
ObjBA_Main:
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB66:
ObjBA_SubObjData:
	subObjData ObjBA_MapUnc_3BB70,make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1),1<<render_flags.level_fg,4,$10,0

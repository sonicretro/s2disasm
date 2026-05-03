; ----------------------------------------------------------------------------
; Object B7 - Unused huge vertical laser from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B8A6:
ObjB7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB7_Index(pc,d0.w),d1
	jmp	ObjB7_Index(pc,d1.w)
; ===========================================================================
; off_3B8B4:
ObjB7_Index:	offsetTable
		offsetTableEntry.w ObjB7_Init	; 0
		offsetTableEntry.w ObjB7_Main	; 2
; ===========================================================================
; loc_3B8B8:
ObjB7_Init:
	bsr.w	LoadSubObject
	move.b	#$20,objoff_2A(a0)
	rts
; ===========================================================================
; loc_3B8C4:
ObjB7_Main:
	subq.b	#1,objoff_2A(a0)
	beq.w	JmpTo65_DeleteObject
	bchg	#0,objoff_2B(a0)
	beq.w	return_37A48
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3B8DA:
ObjB7_SubObjData:
	subObjData ObjB7_MapUnc_3B8E4,make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1),1<<render_flags.level_fg,4,$18,$A9

; ----------------------------------------------------------------------------
; Object B4 - Vertical propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B36A:
ObjB4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB4_Index(pc,d0.w),d1
	jmp	ObjB4_Index(pc,d1.w)
; ===========================================================================
; off_3B378:
ObjB4_Index:	offsetTable
		offsetTableEntry.w ObjB4_Init	; 0
		offsetTableEntry.w ObjB4_Main	; 2
; ===========================================================================
; loc_3B37C:
ObjB4_Init:
	bsr.w	LoadSubObject
	bclr	#render_flags.y_flip,render_flags(a0)
	beq.s	+
	clr.b	collision_flags(a0)
+
	rts
; ===========================================================================
; loc_3B38E:
ObjB4_Main:
	lea	(Ani_objB4).l,a1
	jsrto	JmpTo25_AnimateSprite
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Helicopter),d0
	jsrto	JmpTo_PlaySoundLocal
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3B3AC:
ObjB4_SubObjData:
	subObjData ObjB4_MapUnc_3B3BE,make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1),1<<render_flags.level_fg,4,4,$A8

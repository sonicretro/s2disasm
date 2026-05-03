; ----------------------------------------------------------------------------
; Object AC - Balkiry (jet badnik) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3937A:
ObjAC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAC_Index(pc,d0.w),d1
	jmp	ObjAC_Index(pc,d1.w)
; ===========================================================================
; off_39388:
ObjAC_Index:	offsetTable
		offsetTableEntry.w ObjAC_Init	; 0
		offsetTableEntry.w ObjAC_Main	; 2
; ===========================================================================
; loc_3938C:
ObjAC_Init:
	bsr.w	LoadSubObject
	move.b	#1,mapping_frame(a0)
	move.w	#-$300,x_vel(a0)
	bclr	#render_flags.y_flip,render_flags(a0)
	beq.s	+
	move.w	#-$500,x_vel(a0)
+
	lea_	Ani_obj9C,a1
	move.l	a1,objoff_2E(a0)
	bra.w	loc_37ABE
; ===========================================================================
; loc_393B6:
ObjAC_Main:
	jsrto	JmpTo26_ObjectMove
	bsr.w	loc_36776
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_393C2:
ObjAC_SubObjData:
	subObjData ObjAC_MapUnc_393CC,make_art_tile(ArtTile_ArtNem_Balkrie,0,0),1<<render_flags.level_fg,4,$20,8

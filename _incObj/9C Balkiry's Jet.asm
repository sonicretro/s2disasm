; ----------------------------------------------------------------------------
; Object 9C - Balkiry's jet from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37A82:
Obj9C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9C_Index(pc,d0.w),d1
	jmp	Obj9C_Index(pc,d1.w)
; ===========================================================================
; off_37A90:
Obj9C_Index:	offsetTable
		offsetTableEntry.w Obj9C_Init
		offsetTableEntry.w Obj9C_Main
; ===========================================================================
; BranchTo2_LoadSubObject
Obj9C_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_37A98:
Obj9C_Main:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	objoff_32(a0),d0
	cmp.b	id(a1),d0
	bne.w	JmpTo65_DeleteObject
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	movea.l	objoff_2E(a0),a1
	jsrto	JmpTo25_AnimateSprite
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================

loc_37ABE:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_BalkiryJet,id(a1) ; load obj9C
	move.b	#6,mapping_frame(a1)
	move.b	#$1A,subtype(a1) ; <== Obj9C_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	objoff_2E(a0),objoff_2E(a1)
	move.b	id(a0),objoff_32(a1)
+
	rts

; ===========================================================================
; this code is for Obj9A

loc_37AF2:
	jsrto	JmpTo19_AllocateObject
	bne.s	+	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$1C,subtype(a1) ; <== Obj9A_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	subi.w	#$14,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$A,y_pos(a1)
	move.w	#-$100,x_vel(a1)
	lea_	Obj98_TurtloidShotMove,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
; off_37B32:
Obj9A_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),1<<render_flags.level_fg,5,$18,0
; off_37B3C:
Obj9B_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),1<<render_flags.level_fg,4,$C,$1A
; off_37B46:
Obj9C_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),1<<render_flags.level_fg,5,8,0

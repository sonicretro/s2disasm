; ----------------------------------------------------------------------------
; Object BC - Fire coming out of Robotnik's ship in WFZ
; ----------------------------------------------------------------------------
; Sprite_3BBBC:
ObjBC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBC_Index(pc,d0.w),d1
	jmp	ObjBC_Index(pc,d1.w)
; ===========================================================================
; off_3BBCA:
ObjBC_Index:	offsetTable
		offsetTableEntry.w ObjBC_Init
		offsetTableEntry.w ObjBC_Main
; ===========================================================================
; loc_3BBCE:
ObjBC_Init:
	bsr.w	LoadSubObject
	move.w	x_pos(a0),objoff_2C(a0)
	rts
; ===========================================================================
; loc_3BBDA:
ObjBC_Main:
	move.w	objoff_2C(a0),d0
	move.w	(Camera_BG_X_offset).w,d1
	cmpi.w	#$380,d1
	bhs.w	JmpTo65_DeleteObject
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bchg	#0,objoff_2A(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; off_3BBFE:
ObjBC_SubObjData2:
	subObjData ObjBC_MapUnc_3BC08,make_art_tile(ArtTile_ArtNem_WfzThrust,2,0),1<<render_flags.level_fg,4,$10,0

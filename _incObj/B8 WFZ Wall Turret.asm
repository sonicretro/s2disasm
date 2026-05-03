; ----------------------------------------------------------------------------
; Object B8 - Wall turret from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B968:
ObjB8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB8_Index(pc,d0.w),d1
	jmp	ObjB8_Index(pc,d1.w)
; ===========================================================================
; off_3B976:
ObjB8_Index:	offsetTable
		offsetTableEntry.w ObjB8_Init	; 0
		offsetTableEntry.w loc_3B980	; 2
		offsetTableEntry.w loc_3B9AA	; 4
; ===========================================================================
; BranchTo5_LoadSubObject
ObjB8_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3B980:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	+
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d1
	beq.s	+
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	++
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#2,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9AA:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#0,d6
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	blo.s	loc_3B9C0
	move.w	d0,d6
	lsr.w	#1,d6
	addq.w	#1,d6

loc_3B9C0:
	move.b	d6,mapping_frame(a0)
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$60,objoff_2A(a0)
	bsr.w	loc_3B9D8
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9D8:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$8E,subtype(a1) ; <== ObjB8_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	lea_	Obj98_WallTurretShotMove,a2
	move.l	a2,objoff_2A(a1)
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	lsl.w	#2,d0
	lea	byte_3BA2A(pc,d0.w),a2
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,x_pos(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,y_pos(a1)
	move.b	(a2)+,x_vel(a1)
	move.b	(a2)+,y_vel(a1)
+
	rts
; ===========================================================================
byte_3BA2A:
	dc.b   0
	dc.b $18	; 1
	dc.b   0	; 2
	dc.b   1	; 3
	dc.b $EF	; 4
	dc.b $10	; 5
	dc.b $FF	; 6
	dc.b   1	; 7
	dc.b $11	; 8
	dc.b $10	; 9
	dc.b   1	; 10
	dc.b   1	; 11
	even
; off_3BA36:
ObjB8_SubObjData:
	subObjData ObjB8_Obj98_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),1<<render_flags.level_fg,4,$10,0

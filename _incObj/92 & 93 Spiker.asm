; ----------------------------------------------------------------------------
; Object 92 - Spiker (drill badnik) from HTZ
; ----------------------------------------------------------------------------
; Sprite_36F0E:
Obj92:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj92_Index(pc,d0.w),d1
	jmp	Obj92_Index(pc,d1.w)
; ===========================================================================
; off_36F1C:
Obj92_Index:	offsetTable
		offsetTableEntry.w Obj92_Init	; 0
		offsetTableEntry.w loc_36F3C	; 2
		offsetTableEntry.w loc_36F68	; 4
		offsetTableEntry.w loc_36F90	; 6
; ===========================================================================
; loc_36F24:
Obj92_Init:
	bsr.w	LoadSubObject
	move.b	#$40,objoff_2A(a0)
	move.w	#$80,x_vel(a0)
	bchg	#status.npc.x_flip,status(a0)
	rts
; ===========================================================================

loc_36F3C:
	bsr.w	loc_3703E
	bne.s	loc_36F48
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36F5A

loc_36F48:
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_obj92).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_36F5A:
	addq.b	#2,routine(a0)
	move.b	#$10,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_36F68:
	bsr.w	loc_3703E
	bne.s	+
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36F78
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_36F78:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#status.npc.x_flip,status(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_36F90:
	move.b	objoff_2E(a0),d0
	cmpi.b	#8,d0
	beq.s	loc_36FA4
	subq.b	#1,d0
	move.b	d0,objoff_2E(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_36FA4:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	loc_36FDC
	st.b	objoff_2B(a0)
	_move.b	#ObjID_SpikerDrill,id(a1) ; load obj93
	move.b	subtype(a0),subtype(a1)
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#2,mapping_frame(a0)
	move.b	#1,anim(a0)

loc_36FDC:
	move.b	objoff_2F(a0),routine(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 93 - Drill thrown by Spiker from HTZ
; ----------------------------------------------------------------------------
; Sprite_36FE6:
Obj93:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj93_Index(pc,d0.w),d1
	jmp	Obj93_Index(pc,d1.w)
; ===========================================================================
; off_36FF4:
Obj93_Index:	offsetTable
		offsetTableEntry.w Obj93_Init	; 0
		offsetTableEntry.w loc_37028	; 2
; ===========================================================================
; loc_36FF8:
Obj93_Init:
	bsr.w	LoadSubObject
	ori.b	#1<<render_flags.on_screen,render_flags(a0)
	ori.b	#$80,collision_flags(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	render_flags(a1),d0
	andi.b	#3,d0
	or.b	d0,render_flags(a0)
	moveq	#2,d1
	btst	#1,d0
	bne.s	+
	neg.w	d1
+
	move.b	d1,y_vel(a0)
	rts
; ===========================================================================

loc_37028:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo65_DeleteObject
	bchg	#render_flags.x_flip,render_flags(a0)
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3703E:
	tst.b	objoff_2B(a0)
	bne.s	loc_37062
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	loc_37062
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	bhs.s	loc_37062
	addi.w	#$80,d3
	cmpi.w	#$100,d3
	blo.s	loc_37066

loc_37062:
	moveq	#0,d0
	rts
; ===========================================================================

loc_37066:
	move.b	routine(a0),objoff_2F(a0)
	move.b	#6,routine(a0)
	move.b	#$10,objoff_2E(a0)
	moveq	#1,d0
	rts
; ===========================================================================
; off_3707C:
Obj92_SubObjData:
	subObjData Obj92_Obj93_MapUnc_37092,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,4,$10,$12

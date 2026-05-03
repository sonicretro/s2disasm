; ----------------------------------------------------------------------------
; Object A1 - Slicer (praying mantis dude) from MTZ
; ----------------------------------------------------------------------------
; Sprite_383B4:
ObjA1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA1_Index(pc,d0.w),d1
	jmp	ObjA1_Index(pc,d1.w)
; ===========================================================================
; off_383C2:
ObjA1_Index:	offsetTable
		offsetTableEntry.w ObjA1_Init	; 0
		offsetTableEntry.w ObjA1_Main	; 2
		offsetTableEntry.w loc_38466	; 4
		offsetTableEntry.w loc_38482	; 6
		offsetTableEntry.w BranchTo5_JmpTo39_MarkObjGone	; 8
; ===========================================================================
; loc_383CC:
ObjA1_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,d0
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_383DE
	neg.w	d0

loc_383DE:
	move.w	d0,x_vel(a0)
	move.b	#$10,y_radius(a0)
	move.b	#$10,x_radius(a0)
	rts
; ===========================================================================

ObjA1_Main:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	loc_3841C
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_38404
	subq.w	#2,d0

loc_38404:
	tst.w	d0
	bne.s	loc_3841C
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	bhs.s	loc_3841C
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	blo.s	loc_38452

loc_3841C:
	jsrto	JmpTo26_ObjectMove
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#-8,d1
	blt.s	loc_38444
	cmpi.w	#$C,d1
	bge.s	loc_38444
	add.w	d1,y_pos(a0)
	lea	(Ani_objA1).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38444:
	addq.b	#2,routine(a0)
	move.b	#$3B,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38452:
	addq.b	#4,routine(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#8,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38466:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_38470
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38470:
	subq.b	#2,routine(a0)
	neg.w	x_vel(a0)
	bchg	#status.npc.x_flip,status(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38482:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_3848C
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3848C:
	addq.b	#2,routine(a0)
	move.b	#4,mapping_frame(a0)
	bsr.w	ObjA1_LoadPincers
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

BranchTo5_JmpTo39_MarkObjGone ; BranchTo
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A2 - Slicer's pincers from MTZ
; ----------------------------------------------------------------------------
; Sprite_384A2:
ObjA2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA2_Index(pc,d0.w),d1
	jmp	ObjA2_Index(pc,d1.w)
; ===========================================================================
; off_384B0:
ObjA2_Index:	offsetTable
		offsetTableEntry.w ObjA2_Init	; 0
		offsetTableEntry.w ObjA2_Main	; 2
		offsetTableEntry.w ObjA2_Main2	; 4
; ===========================================================================
; loc_384B6:
ObjA2_Init:
	bsr.w	LoadSubObject
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

ObjA2_Main:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo65_DeleteObject
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3851A
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Slicer,id(a1)
	bne.s	loc_3851A
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_384F6(pc,d0.w),d1
	jsr	off_384F6(pc,d1.w)
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objA2).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_384F6:	offsetTable
		offsetTableEntry.w +
; ===========================================================================
+
	bsr.w	Obj_GetOrientationToPlayer
	move.w	ObjA2_acceleration(pc,d0.w),d2
	add.w	d2,x_vel(a0)
	move.w	ObjA2_acceleration(pc,d1.w),d2
	add.w	d2,y_vel(a0)
	move.w	#$200,d0
	move.w	d0,d1
	bra.w	Obj_CapSpeed
; ===========================================================================
ObjA2_acceleration:	dc.w -$10, $10
; ===========================================================================

loc_3851A:
	addq.b	#2,routine(a0)
	move.w	#$60,objoff_2A(a0)

ObjA2_Main2:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jsrto	JmpTo8_ObjectMoveAndFall
	lea	(Ani_objA2).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

ObjA1_LoadPincers:
	lea	objoff_3C(a0),a2 ; a2=object
	moveq	#0,d1
	moveq	#1,d6

loc_38546:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_385BA
	_move.b	#ObjID_SlicerPincers,id(a1) ; load objA2
	move.b	#$2A,subtype(a1) ; <== ObjA2_SubObjData
	move.b	render_flags(a0),render_flags(a1)
	move.b	#5,mapping_frame(a1)
	move.b	#4,priority(a1)
	move.w	#$78,objoff_2A(a1)
	move.w	a0,objoff_2C(a1)
	move.w	a1,(a2)+
	move.w	#-$200,d0
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	loc_3858A
	neg.w	d0
	bset	#status.npc.x_flip,status(a1)

loc_3858A:
	move.w	d0,x_vel(a1)
	lea	ObjA1_Pincer_Offsets(pc,d1.w),a3
	move.b	(a3)+,d0
	ext.w	d0
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	loc_385A0
	neg.w	d0

loc_385A0:
	add.w	x_pos(a0),d0
	move.w	d0,x_pos(a1)
	move.b	(a3)+,d0
	ext.w	d0
	add.w	y_pos(a0),d0
	move.w	d0,y_pos(a1)
	addq.w	#2,d1
	dbf	d6,loc_38546

return_385BA:
	rts
; ===========================================================================
ObjA1_Pincer_Offsets:
	dc.b    6,    0	; 0
	dc.b -$10,    0	; 3
; off_385C0
ObjA1_SubObjData:
	subObjData ObjA1_MapUnc_385E2,make_art_tile(ArtTile_ArtNem_MtzMantis,1,0),1<<render_flags.level_fg,5,$10,6
; off_385CA:
ObjA2_SubObjData:
	subObjData ObjA1_MapUnc_385E2,make_art_tile(ArtTile_ArtNem_MtzMantis,1,0),1<<render_flags.level_fg,4,$10,$9A

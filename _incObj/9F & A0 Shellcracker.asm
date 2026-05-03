; ----------------------------------------------------------------------------
; Object 9F - Shellcracker (crab badnik) from MTZ
; ----------------------------------------------------------------------------
; Sprite_3800C:
Obj9F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9F_Index(pc,d0.w),d1
	jmp	Obj9F_Index(pc,d1.w)
; ===========================================================================
; off_3801A:
Obj9F_Index:	offsetTable
		offsetTableEntry.w Obj9F_Init	; 0
		offsetTableEntry.w loc_3804E	; 2
		offsetTableEntry.w loc_380C4	; 4
		offsetTableEntry.w loc_380FC	; 6
; ===========================================================================
; loc_38022:
Obj9F_Init:
	bsr.w	LoadSubObject
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	bset	#status.npc.x_flip,status(a0)
+
	move.w	#-$40,x_vel(a0)
	move.b	#$C,y_radius(a0)
	move.b	#$18,x_radius(a0)
	move.w	#$140,objoff_2A(a0)
	rts
; ===========================================================================

loc_3804E:
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	beq.s	loc_3805E
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_38068

loc_3805E:
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_380AE

loc_38068:
	jsrto	JmpTo26_ObjectMove
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#-8,d1
	blt.s	loc_38096
	cmpi.w	#$C,d1
	bge.s	loc_38096
	add.w	d1,y_pos(a0)
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3809A
	lea	(Ani_obj9F).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38096:
	neg.w	x_vel(a0)

loc_3809A:
	addq.b	#2,routine(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#$3B,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_380AE:
	move.b	#6,routine(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#8,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_380C4:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	loc_380E4
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	beq.s	loc_380DA
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_380E4

loc_380DA:
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_380AE

loc_380E4:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_380EE
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_380EE:
	subq.b	#2,routine(a0)
	move.w	#$140,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_380FC:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3810E(pc,d0.w),d1
	jsr	off_3810E(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3810E:	offsetTable
		offsetTableEntry.w loc_38114	; 0
		offsetTableEntry.w loc_3812A	; 2
		offsetTableEntry.w loc_3813E	; 4
; ===========================================================================

loc_38114:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3811C
	rts
; ===========================================================================

loc_3811C:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	bra.w	loc_38292
; ===========================================================================

loc_3812A:
	tst.b	objoff_2C(a0)
	bne.s	loc_38132
	rts
; ===========================================================================

loc_38132:
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	rts
; ===========================================================================

loc_3813E:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_38146
	rts
; ===========================================================================

loc_38146:
	clr.b	routine_secondary(a0)
	clr.b	objoff_2C(a0)
	move.b	#2,routine(a0)
	move.w	#$140,objoff_2A(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A0 - Shellcracker's claw from MTZ
; ----------------------------------------------------------------------------
; Sprite_3815C:
ObjA0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA0_Index(pc,d0.w),d1
	jmp	ObjA0_Index(pc,d1.w)
; ===========================================================================
; off_3816A:
ObjA0_Index:	offsetTable
		offsetTableEntry.w ObjA0_Init	; 0
		offsetTableEntry.w loc_381AC	; 2
		offsetTableEntry.w loc_38280	; 4
; ===========================================================================
; loc_38170:
ObjA0_Init:
	bsr.w	LoadSubObject
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	render_flags(a1),d0
	andi.b	#1,d0
	or.b	d0,render_flags(a0)
	move.w	objoff_2E(a0),d0
	beq.s	loc_38198
	move.b	#4,mapping_frame(a0)
	addq.w	#6,x_pos(a0)
	addq.w	#6,y_pos(a0)

loc_38198:
	lsr.w	#1,d0
	move.b	byte_381A4(pc,d0.w),objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
byte_381A4:
	dc.b   0	; 0
	dc.b   3	; 1
	dc.b   5	; 2
	dc.b   7	; 3
	dc.b   9	; 4
	dc.b  $B	; 5
	dc.b  $D	; 6
	dc.b  $F	; 7
	even
; ===========================================================================

loc_381AC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Shellcracker,id(a1)
	bne.s	loc_381D0
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_381C8(pc,d0.w),d1
	jsr	off_381C8(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_381C8:	offsetTable
		offsetTableEntry.w loc_381E0	; 0
		offsetTableEntry.w loc_3822A	; 2
		offsetTableEntry.w loc_38244	; 4
		offsetTableEntry.w loc_38258	; 6
; ===========================================================================

loc_381D0:
	move.b	#4,routine(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_381E0:
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_381EA
	bmi.s	loc_381EA
	rts
; ===========================================================================

loc_381EA:
	addq.b	#2,routine_secondary(a0)
	move.w	objoff_2E(a0),d0
	cmpi.w	#$E,d0
	bhs.s	loc_3821A
	move.w	#-$400,d2
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_38206
	neg.w	d2

loc_38206:
	move.w	d2,x_vel(a0)
	lsr.w	#1,d0
	move.b	byte_38222(pc,d0.w),d1
	move.b	d1,objoff_2A(a0)
	move.b	d1,objoff_2B(a0)
	rts
; ===========================================================================

loc_3821A:
	move.w	#$B,objoff_2A(a0)
	rts
; ===========================================================================
byte_38222:
	dc.b  $D	; 0
	dc.b  $C	; 1
	dc.b  $A	; 2
	dc.b   8	; 3
	dc.b   6	; 4
	dc.b   4	; 5
	dc.b   2	; 6
	dc.b   0	; 7
	even
; ===========================================================================

loc_3822A:
	jsrto	JmpTo26_ObjectMove
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_38238
	bmi.s	loc_38238
	rts
; ===========================================================================

loc_38238:
	addq.b	#2,routine_secondary(a0)
	move.b	#8,objoff_2A(a0)
	rts
; ===========================================================================

loc_38244:
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_3824E
	bmi.s	loc_3824E
	rts
; ===========================================================================

loc_3824E:
	addq.b	#2,routine_secondary(a0)
	neg.w	x_vel(a0)
	rts
; ===========================================================================

loc_38258:
	jsrto	JmpTo26_ObjectMove
	subq.b	#1,objoff_2B(a0)
	beq.s	loc_38266
	bmi.s	loc_38266
	rts
; ===========================================================================

loc_38266:
	tst.w	objoff_2E(a0)
	bne.s	loc_3827A
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	#0,mapping_frame(a1)
	st.b	objoff_2C(a1)

loc_3827A:
	addq.w	#4,sp
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

loc_38280:
	jsrto	JmpTo8_ObjectMoveAndFall
	subi_.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38292:
	moveq	#0,d1
	moveq	#7,d6

loc_38296:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_382EE
	_move.b	#ObjID_ShellcrackerClaw,id(a1) ; load objA0
	move.b	#$26,subtype(a1) ; <== ObjA0_SubObjData
	move.b	#5,mapping_frame(a1)
	move.b	#4,priority(a1)
	move.w	a0,objoff_2C(a1)
	move.w	d1,objoff_2E(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	#-$14,d2
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_382D8
	neg.w	d2
	tst.w	d1
	beq.s	loc_382D8
	subi.w	#$C,d2

loc_382D8:
	add.w	d2,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi_.w	#8,y_pos(a1)
	addq.w	#2,d1
	dbf	d6,loc_38296

return_382EE:
	rts
; ===========================================================================
; off_382F0:
Obj9F_SubObjData:
	subObjData Obj9F_MapUnc_38314,make_art_tile(ArtTile_ArtNem_Shellcracker,0,0),1<<render_flags.level_fg,5,$18,$A
; off_382FA:
ObjA0_SubObjData:
	subObjData Obj9F_MapUnc_38314,make_art_tile(ArtTile_ArtNem_Shellcracker,0,0),1<<render_flags.level_fg,4,$C,$9A
